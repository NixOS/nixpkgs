{
  fetchFromGitHub,
  stdenv,
  lib,
  cmake,
  qt5,
}:
stdenv.mkDerivation rec {
  pname = "qhttpengine";
  version = "0-unstable-2018-03-22";
  src = fetchFromGitHub {
    owner = "nitroshare";
    repo = "qhttpengine";
    rev = "43f55df51623621ed3efb4e42c7894586d988667";
    hash = "sha256-XO56DUKyUIOhp+xpArMeoNHmlgAld9tUFMCY+tjyI4M=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [ qt5.qtbase ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "HTTP server for Qt applications";
    homepage = "https://github.com/nitroshare/qhttpengine";
    license = lib.licenses.mit;
  };
}
