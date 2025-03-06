{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, perl
, kdePackages
, libtoxcore
, libpthreadstubs
, libXdmcp
, libXScrnSaver
, ffmpeg
, filter-audio
, libexif
, libsodium
, libopus
, libvpx
, openal
, pcre
, qrencode
, qt6
, sqlcipher
}:

stdenv.mkDerivation rec {
  pname = "qtox";
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "TokTok";
    repo = "qTox";
    tag = "v${version}";
    hash = "sha256-NPJ1tBIcM4zR5izsoiydUO2+cEuWOdWAf2xte7bwOxg=";
  };

  buildInputs = [
    kdePackages.sonnet
    libtoxcore
    libpthreadstubs
    libXdmcp
    libXScrnSaver
    ffmpeg
    filter-audio
    libexif
    libopus
    libsodium
    libvpx
    openal
    pcre
    qrencode
    qt6.qtbase
    qt6.qtsvg
    sqlcipher
  ];

  nativeBuildInputs = [ cmake pkg-config qt6.qttools qt6.wrapQtAppsHook ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ perl ];

  cmakeFlags = [
    "-DGIT_DESCRIBE=v${version}"
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
