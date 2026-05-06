{
  lib,
  fetchFromGitHub,
  python3Packages,
  kicad9,
  interactive-html-bom-inti-cmnb,
  symlinkJoin,
}:

let
  libraries = kicad9.libraries;

  # KICAD9_TEMPLATE_DIR only works with a single path (it does not handle : separated paths)
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
  version = "1.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "INTI-CMNB";
    repo = "KiBot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9evd7zTGg0csoKGT46w0sE+Ug0Gtn2LuiOlmw4mcNcQ=";
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
    kicad9
    lxml
    interactive-html-bom-inti-cmnb
  ];

  buildInputs = [ kicad9 ];

  patches = [
    ./fix-interactive-html-bom.patch
  ];

  postFixup = ''
    wrapProgram $out/bin/kibot \
      --set KICAD_PATH "${kicad9}" \
      --set KICAD9_FOOTPRINT_DIR ${libraries.footprints}/share/kicad/footprints \
      --set KICAD9_SYMBOL_DIR ${libraries.symbols}/share/kicad/symbols \
      --set KICAD9_TEMPLATE_DIR ${template_dir} \
      --set KICAD9_3DMODEL_DIR ${libraries.packages3d}/share/kicad/3dmodels
  '';

  postInstall = ''
    find $out -name '*.pyc' -delete
    find $out -name '__pycache__' -type d -exec rm -r {} +
  '';

  __structuredAttrs = true;

  meta = {
    description = "Tool for generating fabrication and documentation files for KiCad";
    homepage = "https://github.com/INTI-CMNB/KiBot";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ scd31 ];
    mainProgram = "kibot";
  };
})
