{ stdenv, mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, libtoxcore
, libpthreadstubs, libXdmcp, libXScrnSaver
, qtbase, qtsvg, qttools, qttranslations
, ffmpeg, filter-audio, libexif, libsodium, libopus
, libvpx, openal, pcre, qrencode, sqlcipher
, AVFoundation ? null }:

let
  version = "1.15.0";
  rev = "v${version}";

in mkDerivation rec {
  name = "qtox-${version}";

  src = fetchFromGitHub {
    owner  = "qTox";
    repo   = "qTox";
    sha256 = "1garwnlmg452b0bwx36rsh08s15q3zylb26l01iiwg4l9vcaldh9";
    inherit rev;
  };

  buildInputs = [
    libtoxcore
    libpthreadstubs libXdmcp libXScrnSaver
    qtbase qtsvg qttranslations
    ffmpeg filter-audio libexif libopus libsodium
    libvpx openal pcre qrencode sqlcipher
  ] ++ lib.optionals stdenv.isDarwin [ AVFoundation] ;

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DGIT_DESCRIBE=${rev}"
    "-DENABLE_STATUSNOTIFIER=False"
    "-DENABLE_GTK_SYSTRAY=False"
    "-DENABLE_APPINDICATOR=False"
    "-DTIMESTAMP=1"
  ];

  meta = with lib; {
    description = "Qt Tox client";
    homepage    = https://tox.chat;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds akaWolf peterhoeg ];
    platforms   = platforms.all;
  };
}
