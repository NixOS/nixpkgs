{ stdenv, mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, libtoxcore
, libpthreadstubs, libXdmcp, libXScrnSaver
, qtbase, qtsvg, qttools, qttranslations
, ffmpeg_3, filter-audio, libexif, libsodium, libopus
, libvpx, openal, pcre, qrencode, sqlcipher
, AVFoundation ? null }:

let
  version = "1.17.2";
  rev = "v${version}";

in mkDerivation {
  pname = "qtox";
  inherit version;

  src = fetchFromGitHub {
    owner  = "qTox";
    repo   = "qTox";
    sha256 = "04pbv1zsxy8dph2v0r9xc8lcm5g6604pwnppi3la5w46ihbwxlb9";
    inherit rev;
  };

  buildInputs = [
    libtoxcore
    libpthreadstubs libXdmcp libXScrnSaver
    qtbase qtsvg qttranslations
    ffmpeg_3 filter-audio libexif libopus libsodium
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
    homepage    = "https://tox.chat";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ akaWolf peterhoeg ];
    platforms   = platforms.all;
  };
}
