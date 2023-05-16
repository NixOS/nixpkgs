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
<<<<<<< HEAD
  version = "3.9.0";
=======
  version = "3.7.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "martchus";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-caki8WVnu8ELE2mXwRvT9TTTXCtMZEa0E3KVpHl05jg=";
=======
    hash = "sha256-QQvc9S+9h0Qy/qBROwJMZIALf/Rbj/9my4PZGxQzlnM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "tageditor";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
