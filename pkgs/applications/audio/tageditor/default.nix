{ stdenv
, pkgs
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
  version = "3.3.10";

  src = fetchFromGitHub {
    owner = "martchus";
    repo = "tageditor";
    rev = "v${version}";
    sha256 = "16cmq7dyalcwc8gx1y9acngw5imjh8ydp4prxy7qpzk4fj3kpsak";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    mp4v2
    libid3tag
    pkg-config
    qtbase
    qttools
    qtx11extras
    qtwebengine
    cpp-utilities
    qtutilities
    tagparser
  ];

  meta = with pkgs.lib; {
    homepage = "https://github.com/Martchus/tageditor";
    description = "A tag editor with Qt GUI and command-line interface supporting MP4/M4A/AAC (iTunes), ID3, Vorbis, Opus, FLAC and Matroska";
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux;
  };
}

