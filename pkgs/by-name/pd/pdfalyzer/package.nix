{
  lib,
  python3Packages,
  fetchFromGitHub,
  pkgs,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pdfalyzer";
  version = "1.19.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "michelcrypt4d4mus";
    repo = "pdfalyzer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pwDQtyMSbqn/DMwR+9nTnpy8X4KmjEN+HVZf1F+MYt4=";
  };

  pythonRelaxDeps = [ "pypdf" ];

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    anytree
    cairosvg
    cryptography
    numpy
    pkgs.yaralyzer
    pymupdf
    pypdf
    pytesseract
    requests
  ];

  pythonImportsCheck = [ "pdfalyzer" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to analyze PDFs with colors";
    homepage = "https://github.com/michelcrypt4d4mus/pdfalyzer";
    changelog = "https://github.com/michelcrypt4d4mus/pdfalyzer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Only
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pdfalyzer";
  };
})
