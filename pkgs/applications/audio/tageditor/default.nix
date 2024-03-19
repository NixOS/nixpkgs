{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, cmake
, cpp-utilities
, qtutilities
, mp4v2
, libid3tag
, qtbase
, qttools
, qtwebengine
, qtx11extras
, tagparser
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "tageditor";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "martchus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-caki8WVnu8ELE2mXwRvT9TTTXCtMZEa0E3KVpHl05jg=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    mp4v2
    libid3tag
    qtbase
    qttools
    qtx11extras
    qtwebengine
    cpp-utilities
    qtutilities
    tagparser
  ];

  meta = with lib; {
    homepage = "https://github.com/Martchus/tageditor";
    description = "A tag editor with Qt GUI and command-line interface supporting MP4/M4A/AAC (iTunes), ID3, Vorbis, Opus, FLAC and Matroska";
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux;
    mainProgram = "tageditor";
  };
}
