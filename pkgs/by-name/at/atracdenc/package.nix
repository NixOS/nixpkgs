{
  cmake,
  fetchFromGitHub,
  lib,
  libsndfile,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "atracdenc";
  version = "0-unstable-2025-01-04";

  src = fetchFromGitHub {
    owner = "dcherednik";
    repo = "atracdenc";
    rev = "0fe8e1a0d1a495e41a281f54af31d6713c0de01d";
    hash = "sha256-Tpg9YOE+UUhNMX2sWZiuM6w4IulYuiwFJFUR9HIMoNU=";
  };

  buildInputs = [
    libsndfile
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "ATRAC decoder/encoder";
    license = lib.licenses.lgpl21Plus;
    homepage = "https://github.com/dcherednik/atracdenc";
    maintainers = with lib.maintainers; [ ddelabru ];
    mainProgram = "atracdenc";
    platforms = lib.platforms.all;
  };
}
