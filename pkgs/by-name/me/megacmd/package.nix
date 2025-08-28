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
  srcOptions =
    if stdenv.hostPlatform.isLinux then
      {
        tag = "${version}_Linux";
        hash = "sha256-UlSqwM8GQKeG8/K0t5DbM034NQOeBg+ujNi/MMsVCuM=";
      }
    else
      {
        tag = "${version}_macOS";
        hash = "sha256-UlSqwM8GQKeG8/K0t5DbM034NQOeBg+ujNi/MMsVCuM=";
      };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub (
    srcOptions
    // {
      owner = "meganz";
      repo = "MEGAcmd";
      fetchSubmodules = true;
    }
  );

  enableParallelBuilding = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ gcc-unwrapped ] # fix: ld: cannot find lib64/libstdc++fs.a
    ++ [
      c-ares
      cryptopp
      curl
      ffmpeg
      icu
      libmediainfo
      libraw
      libsodium
      libuv
      libzen
      pcre-cpp
      readline
      sqlite
    ]
    ++ lib.optionals withFreeImage [ freeimage ];

  configureFlags = [
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
  ]
  ++ (if withFreeImage then [ "--with-freeimage" ] else [ "--without-freeimage" ]);

  # On darwin, some macros defined in AssertMacros.h (from apple-sdk) are conflicting.
  postConfigure = ''
    echo '#define __ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES 0' >> sdk/include/mega/config.h
  '';

  patches = [
    ./fix-ffmpeg.patch # https://github.com/meganz/sdk/issues/2635#issuecomment-1495405085
    ./fix-darwin.patch # fix: libtool tag not found; MacFileSystemAccess not declared; server cannot init
  ];

  meta = {
    description = "MEGA Command Line Interactive and Scriptable Application";
    homepage = "https://mega.io/cmd";
    license = with lib.licenses; [
      bsd2
      gpl3Only
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      lunik1
      ulysseszhan
    ];
  };
}
