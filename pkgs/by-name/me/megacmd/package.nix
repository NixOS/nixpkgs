{
  lib,
  stdenv,
  autoreconfHook,
  c-ares,
  cryptopp,
  curl,
  fetchFromGitHub,
  ffmpeg,
  freeimage,
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
  withFreeImage ? false, # default to false because freeimage is insecure
}:

let
  pname = "megacmd";
  version = "1.7.0";
in
stdenv.mkDerivation {
  inherit pname version;

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
    ffmpeg
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
  ] ++ lib.optionals withFreeImage [ freeimage ];

  configureFlags = [
    "--disable-curl-checks"
    "--disable-examples"
    "--with-cares"
    "--with-cryptopp"
    "--with-curl"
    "--with-ffmpeg"
    "--with-icu"
    "--with-libmediainfo"
    "--with-libuv"
    "--with-libzen"
    "--with-pcre"
    "--with-readline"
    "--with-sodium"
    "--with-termcap"
  ] ++ (if withFreeImage then [ "--with-freeimage" ] else [ "--without-freeimage" ]);

  patches = [
    ./fix-ffmpeg.patch # https://github.com/meganz/sdk/issues/2635#issuecomment-1495405085
  ];

  meta = {
    description = "MEGA Command Line Interactive and Scriptable Application";
    homepage = "https://mega.io/cmd";
    license = with lib.licenses; [
      bsd2
      gpl3Only
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      lunik1
      ulysseszhan
    ];
  };
}
