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
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "martchus";
    repo = "tageditor";
    rev = "v${version}";
    sha256 = "08and6gfmj4i96ls2g1b9llsb100mw3i37qzgpr76ywkkqnq0r2n";
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

