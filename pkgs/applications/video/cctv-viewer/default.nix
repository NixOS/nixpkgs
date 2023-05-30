{ cmake
, fetchFromGitHub
, ffmpeg_4
, lib
, libsForQt5
, makeDesktopItem
, makeWrapper
, pkg-config
, stdenv
}:

let
  inherit (libsForQt5) qtbase wrapQtAppsHook qtmultimedia qttools;
in
stdenv.mkDerivation rec {
  pname = "cctv-viewer";
  version = "0.1.8";

  src = fetchGit {
    url = "https://github.com/iEvgeny/cctv-viewer";
    submodules = true;
    rev = "d7543f51c0b92d5c6292687794cda4f49c337144";
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    wrapQtAppsHook
  ];

  buildInputs = [
    ffmpeg_4
    qtbase
    qtmultimedia
    qttools
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "CCTV Viewer";
      desktopName = "cctv-viewer";
      comment = "Application for viewing multiple video streams";
      icon = "CCTVViewerLogo";
      exec = "cctv-viewer";
      terminal = false;
      categories = [ "Video" ];
      startupNotify = true;
    })
  ];

  postPatch = ''
    sed -i '/install(FILES/d' CMakeLists.txt
  '';

  meta = with lib; {
    description = "A simple application for simultaneously viewing multiple video streams";
    homepage = "https://github.com/iEvgeny/cctv-viewer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ toolbox ];
    platforms = platforms.linux;
  };
}
