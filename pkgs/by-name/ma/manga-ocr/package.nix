{
  lib,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "manga-ocr";
  version = "0.1.13";
  disabled = python3.pkgs.pythonOlder "3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kha-white";
    repo = "manga-ocr";
    rev = "refs/tags/v${version}";
    hash = "sha256-0EwXDMnA9SCmSsMVXnMenSFSzs74lorFNNym9y/NNsI=";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    fire
    fugashi
    jaconv
    loguru
    numpy
    pillow
    pyperclip
    torch
    transformers
    unidic-lite
  ];

  meta = {
    description = "Optical character recognition for Japanese text, with the main focus being Japanese manga";
    homepage = "https://github.com/kha-white/manga-ocr";
    changelog = "https://github.com/kha-white/manga-ocr/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ laurent-f1z1 ];
  };
}
