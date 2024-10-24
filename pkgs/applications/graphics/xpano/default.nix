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
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "xpano";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "krupkat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CgUiZHjWQSoAam2Itan3Zadt8+w6j9W5KGMZ5f6bHiQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook3
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
    description = "Panorama stitching tool";
    mainProgram = "Xpano";
    homepage = "https://krupkat.github.io/xpano/";
    changelog = "https://github.com/krupkat/xpano/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ krupkat ];
    platforms = platforms.linux;
  };
}
