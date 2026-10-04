{
  lib,
  fetchFromGitHub,
  python3Packages,
  kicad,
  interactive-html-bom-inti-cmnb,
  symlinkJoin,
  nix-update-script,
}:

let
  libraries = kicad.libraries;

  # KICAD10_TEMPLATE_DIR only works with a single path (it does not handle : separated paths)
  # but it's used to find both the templates and the symbol/footprint library tables
  # https://gitlab.com/kicad/code/kicad/-/issues/14792
  template_dir = symlinkJoin {
    name = "KiCad_template_dir";
    paths = with libraries; [
      "${templates}/share/kicad/template"
      "${footprints}/share/kicad/template"
      "${symbols}/share/kicad/template"
    ];
  };
in

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kibot";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "INTI-CMNB";
    repo = "KiBot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aXlo2Mv9X6pxYo2gmI3zfHVDddeDLBISeo+bu4moBts=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonPath = with python3Packages; [
    kiauto
    pyyaml
    xlsxwriter
    colorama
    requests
    qrcodegen
    markdown2
    lark
    kicad
    lxml
    interactive-html-bom-inti-cmnb
  ];

  buildInputs = [ kicad ];

  patches = [
    ./fix-interactive-html-bom.patch
  ];

  postFixup = ''
    wrapProgram $out/bin/kibot \
      --set KICAD_PATH "${kicad}" \
      --set KICAD10_FOOTPRINT_DIR ${libraries.footprints}/share/kicad/footprints \
      --set KICAD10_SYMBOL_DIR ${libraries.symbols}/share/kicad/symbols \
      --set KICAD10_TEMPLATE_DIR ${template_dir} \
      --set KICAD10_3DMODEL_DIR ${libraries.packages3d}/share/kicad/3dmodels
  '';

  postInstall = ''
    find $out -name '*.pyc' -delete
    find $out -name '__pycache__' -type d -exec rm -r {} +
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v(\\d.\\d.\\d)" ];
  };

  __structuredAttrs = true;

  meta = {
    description = "Tool for generating fabrication and documentation files for KiCad";
    homepage = "https://github.com/INTI-CMNB/KiBot";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ n3tcat ];
    mainProgram = "kibot";
  };
})
