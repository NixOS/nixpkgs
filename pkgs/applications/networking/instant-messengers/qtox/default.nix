{ stdenv, mkDerivation, fetchFromGitHub, cmake, pkg-config, perl
, libtoxcore, libpthreadstubs, libXdmcp, libXScrnSaver
, qtbase, qtsvg, qttools, qttranslations
, ffmpeg_3, filter-audio, libexif, libsodium, libopus
, libvpx, openal, pcre, qrencode, sqlcipher
, AVFoundation }:

mkDerivation rec {
  pname = "qtox";
  version = "1.17.3";

  src = fetchFromGitHub {
    owner = "qTox";
    repo = "qTox";
    rev = "v${version}";
    sha256 = "19xgw9bqirxbgvj5cdh20qxh61pkwk838lq1l78n6py1qrs7z5wp";
  };

  buildInputs = [
    libtoxcore
    libpthreadstubs libXdmcp libXScrnSaver
    qtbase qtsvg qttranslations
    ffmpeg_3 filter-audio libexif libopus libsodium
    libvpx openal pcre qrencode sqlcipher
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ AVFoundation] ;

  nativeBuildInputs = [ cmake pkg-config qttools ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ perl ];

  cmakeFlags = [
    "-DGIT_DESCRIBE=v${version}"
    "-DENABLE_STATUSNOTIFIER=False"
    "-DENABLE_GTK_SYSTRAY=False"
    "-DENABLE_APPINDICATOR=False"
    "-DTIMESTAMP=1"
  ];

  meta = with stdenv.lib; {
    description = "Qt Tox client";
    homepage = "https://tox.chat";
    license = licenses.gpl3;
    maintainers = with maintainers; [ akaWolf peterhoeg ];
    platforms = platforms.all;
  };
}
