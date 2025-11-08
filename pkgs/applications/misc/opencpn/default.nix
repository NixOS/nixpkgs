{
  stdenv,
  lib,
  DarwinTools,
  alsa-utils,
  at-spi2-core,
  cmake,
  curl,
  dbus,
  elfutils,
  fetchFromGitHub,
  flac,
  gitMinimal,
  wrapGAppsHook3,
  glew,
  gtest,
  jasper,
  lame,
  libGLU,
  libarchive,
  libdatrie,
  libepoxy,
  libexif,
  libogg,
  libopus,
  libselinux,
  libsepol,
  libsndfile,
  libthai,
  libunarr,
  libusb1,
  libvorbis,
  libxkbcommon,
  lsb-release,
  lz4,
  libmpg123,
  makeWrapper,
  pkg-config,
  portaudio,
  rapidjson,
  shapelib,
  sqlite,
  tinyxml,
  util-linux,
  wxGTK32,
  xorg,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencpn";
  version = "5.12.4";

  src = fetchFromGitHub {
    owner = "OpenCPN";
    repo = "OpenCPN";
    rev = "Release_${finalAttrs.version}";
    hash = "sha256-1JCb2aYyjaiUvtYkBFtEdlClmiMABN3a/Hts9V1sbgc=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i '/fixup_bundle/d; /NO_DEFAULT_PATH/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    gtest
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    lsb-release
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    DarwinTools
    makeWrapper
  ];

  buildInputs = [
    at-spi2-core
    curl
    dbus
    flac
    gitMinimal
    shapelib
  ]
  ++ [
    glew
    jasper
    libGLU
    libarchive
    libdatrie
    libepoxy
    libexif
    libogg
    libopus
    libsndfile
    libthai
    libunarr
    libusb1
    libvorbis
    libxkbcommon
    lz4
    libmpg123
    portaudio
    rapidjson
    sqlite
    tinyxml
    wxGTK32
    xz
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-utils
    libselinux
    libsepol
    util-linux
    xorg.libXdmcp
    xorg.libXtst
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [
    elfutils
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    lame
  ];

  cmakeFlags = [
    "-DOCPN_BUNDLE_DOCS=true"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Override OpenCPN platform detection.
    "-DOCPN_TARGET_TUPLE=unknown;unknown;${stdenv.hostPlatform.linuxArch}"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (!stdenv.hostPlatform.isx86) [
      "-DSQUISH_USE_SSE=0"
    ]
  );

  postInstall = lib.optionals stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/OpenCPN.app $out/Applications
    makeWrapper $out/Applications/OpenCPN.app/Contents/MacOS/OpenCPN $out/bin/opencpn
  '';

  doCheck = true;

  meta = with lib; {
    description = "Concise ChartPlotter/Navigator";
    maintainers = with maintainers; [
      kragniz
      lovesegfault
    ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    homepage = "https://opencpn.org/";
  };
})
