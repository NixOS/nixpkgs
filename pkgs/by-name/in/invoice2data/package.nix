{
  lib,
  fetchFromGitHub,
  ghostscript,
  imagemagick,
  poppler-utils,
  python3,
  tesseract5,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "invoice2data";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "invoice-x";
    repo = "invoice2data";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tbPl23r8j+LdlzOvP37D9SBAdeFVTx1+rAflSo+XqRM=";
  };

  build-system = with python3.pkgs; [
    setuptools
    mypy
    ast-serialize
    click
    pyyaml
    regex
  ];

  dependencies = with python3.pkgs; [
    click
    python-dateutil
    pyyaml
    regex
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ghostscript
      imagemagick
      tesseract5
      poppler-utils
    ])
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  pythonImportsCheck = [
    "invoice2data"
  ];

  meta = {
    description = "Data extractor for PDF invoices";
    mainProgram = "invoice2data";
    homepage = "https://github.com/invoice-x/invoice2data";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
})
