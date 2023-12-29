# From NUR https://github.com/nix-community/nur-combined/blob/6bddae47680482383b5769dd3aa7d82b88e6cbc8/repos/renesat/pkgs/normcap/default.nix

{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  tesseract4,
  leptonica,
  wl-clipboard
}:
python3.pkgs.buildPythonApplication rec {
  pname = "normcap";
  version = "0.4.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dynobo";
    repo = "normcap";
    rev = "v${version}";
    hash = "sha256-dShtmoqS9TC3PHuwq24OEOhYfBHGhDCma8Du8QCkFuI=";
  };

  buildInputs = [
    wl-clipboard
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    tesseract4
    leptonica
    pyside6

    # Test
    toml
    pytest-qt
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace 'PySide6-Essentials = "6.5.1"' ""
  '';

  meta = with lib; {
    description = "OCR powered screen-capture tool to capture information instead of images";
    homepage = "https://dynobo.github.io/normcap/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cafkafk ];
  };
}
