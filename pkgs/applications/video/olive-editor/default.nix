{ lib, stdenv, fetchFromGitHub
, pkg-config, which, qmake, wrapQtAppsHook
, qtmultimedia, frei0r, opencolorio_1, ffmpeg-full, CoreFoundation }:

stdenv.mkDerivation rec {
  pname = "olive-editor";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "olive-editor";
    repo = "olive";
    rev = version;
    sha256 = "151g6jwhipgbq4llwib92sq23p1s9hm6avr7j4qq3bvykzrm8z1a";
  };

  nativeBuildInputs = [
    pkg-config
    which
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    ffmpeg-full
    frei0r
    opencolorio_1
    qtmultimedia
  ] ++ lib.optional stdenv.isDarwin CoreFoundation;

  meta = with lib; {
    description = "Professional open-source NLE video editor";
    homepage = "https://www.olivevideoeditor.org/";
    downloadPage = "https://www.olivevideoeditor.org/download.php";
    license = licenses.gpl3;
    maintainers = [ maintainers.balsoft ];
    platforms = platforms.unix;
  };
}
