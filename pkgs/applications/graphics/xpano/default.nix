{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, ninja
, opencv
, SDL2
, gtk3
, catch2_3
, spdlog
, exiv2
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "xpano";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "krupkat";
    repo = pname;
    rev = "v${version}";
    sha256 = "aKO9NYHFjb69QopseNOJvUvvVT1povP9tyGSOHJFWVo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    opencv
    SDL2
    gtk3
    spdlog
    exiv2
  ];

  checkInputs = [
    catch2_3
  ];

  doCheck = true;

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
    "-DXPANO_INSTALL_DESKTOP_FILES=ON"
  ];

  meta = with lib; {
    description = "A panorama stitching tool";
    homepage = "https://krupkat.github.io/xpano/";
    changelog = "https://github.com/krupkat/xpano/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ krupkat ];
    platforms = platforms.linux;
  };
}
