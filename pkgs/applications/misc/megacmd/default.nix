{
  lib,
  stdenv,
  autoreconfHook,
  c-ares,
  cryptopp,
  curl,
  fetchFromGitHub,
  # build fails with latest ffmpeg, see https://github.com/meganz/MEGAcmd/issues/523.
  # to be re-enabled when patch available
  # , ffmpeg
  gcc-unwrapped,
  icu,
  libmediainfo,
  libraw,
  libsodium,
  libuv,
  libzen,
  pcre-cpp,
  pkg-config,
  readline,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "megacmd";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAcmd";
    rev = "${version}_Linux";
    hash = "sha256-UlSqwM8GQKeG8/K0t5DbM034NQOeBg+ujNi/MMsVCuM=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    c-ares
    cryptopp
    curl
    # ffmpeg
    icu
    gcc-unwrapped
    libmediainfo
    libraw
    libsodium
    libuv
    libzen
    pcre-cpp
    readline
    sqlite
  ];

  configureFlags = [
    "--disable-curl-checks"
    "--disable-examples"
    "--with-cares"
    "--with-cryptopp"
    "--with-curl"
    # "--with-ffmpeg"
    "--without-freeimage" # disabled as freeimage is insecure
    "--with-icu"
    "--with-libmediainfo"
    "--with-libuv"
    "--with-libzen"
    "--with-pcre"
    "--with-readline"
    "--with-sodium"
    "--with-termcap"
  ];

  meta = with lib; {
    description = "MEGA Command Line Interactive and Scriptable Application";
    homepage = "https://mega.io/cmd";
    license = with licenses; [
      bsd2
      gpl3Only
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ lunik1 ];
  };
}
