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
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAcmd";
    rev = "${version}_Linux";
    sha256 = "sha256-JnxfFbM+NyeUrEMok62zlsQIxjrUvLLg4tUTiKPDZFc=";
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
