{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, perl
, libtoxcore
, libpthreadstubs
, libXdmcp
, libXScrnSaver
, qtbase
, qtsvg
, qttools
, ffmpeg
, filter-audio
, libexif
, libsodium
, libopus
, libvpx
, openal
, pcre
, qrencode
, sqlcipher
, AVFoundation
}:

mkDerivation rec {
  pname = "qtox";
  version = "1.17.6";

  src = fetchFromGitHub {
    owner = "qTox";
    repo = "qTox";
    rev = "v${version}";
    sha256 = "sha256-naKWoodSMw0AEtACvkASFmw9t0H0d2pcqOW79NNTYF0=";
  };

  buildInputs = [
    libtoxcore
    libpthreadstubs
    libXdmcp
    libXScrnSaver
    qtbase
    qtsvg
    ffmpeg
    filter-audio
    libexif
    libopus
    libsodium
    libvpx
    openal
    pcre
    qrencode
    sqlcipher
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ AVFoundation ];

  nativeBuildInputs = [ cmake pkg-config qttools ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ perl ];

  cmakeFlags = [
    "-DGIT_DESCRIBE=v${version}"
    "-DENABLE_STATUSNOTIFIER=False"
    "-DENABLE_GTK_SYSTRAY=False"
    "-DENABLE_APPINDICATOR=False"
    "-DTIMESTAMP=1"
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Qt Tox client";
    mainProgram = "qtox";
    homepage = "https://tox.chat";
    license = licenses.gpl3;
    maintainers = with maintainers; [ akaWolf peterhoeg ];
    platforms = platforms.all;
  };
}
