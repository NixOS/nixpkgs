{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "amazing-qr";
  version = "0-unstable-2021-05-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "x-hw";
    repo = "amazing-qr";
    rev = "a773916dcf5bed8fdcd9c492dd552d4044ff568f";
    hash = "sha256-KNGXedVharD/vsAebe9qeG4yFZwZyF77LjPy/LgUF3Y=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    imageio
    numpy
    pillow
  ];

  meta = {
    description = "QR code generator";
    mainProgram = "amzqr";
    maintainers = with lib.maintainers; [ nicknb ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
}
