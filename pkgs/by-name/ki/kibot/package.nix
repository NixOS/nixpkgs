{
  lib,
  python3,
  fetchFromGitHub,

  gitMinimal,
  kicad,
  librsvg,
  ghostscript,
  blender,
  imagemagick,
  pandoc,
  texliveSmall,
  xvfb-run,
  zbar,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "kibot";
  version = "1.9.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "INTI-CMNB";
    repo = "KiBot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7pPusm+X10FMB5Ckety/EDnlhRxBGLczfOdPh72wATg=";
  };

  postPatch = ''
    substituteInPlace kibot/__main__.py \
      --replace-fail "GS.kicad_share_path = '/usr/share/kicad'" "GS.kicad_share_path = '${kicad}'"

    patchShebangs g*.sh
    substituteInPlace g*.sh \
      --replace-fail "pytest-3" "pytest"
  '';

  build-system = [ python3.pkgs.setuptools ];

  dependencies = with python3.pkgs; [
    kicad
    pyyaml
    xlsxwriter
    colorama
    requests
    qrcodegen
    markdown2
    lark
    wxpython
    lxml
  ];

  nativeCheckInputs = [
    python3.pkgs.pytest
    python3.pkgs.coverage
    gitMinimal
    python3.pkgs.kiauto
    python3.pkgs.kicad
    librsvg
    ghostscript
    blender
    imagemagick
    pandoc
    texliveSmall
    xvfb-run
    zbar
  ];

  checkPhase = ''
    runHook preCheck

    export HOME=$TMPDIR

    xvfb-run ./g2.sh
    xvfb-run ./g3.sh
    xvfb-run ./g4.sh

    runHook postCheck
  '';

  meta = {
    description = "Tool for generating fabrication and documentation files for KiCad";
    homepage = "https://github.com/INTI-CMNB/KiBot";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "kibot";
  };
})
