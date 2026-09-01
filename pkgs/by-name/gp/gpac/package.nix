{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  unstableGitUpdater,
  cctools,
  pkg-config,
  zlib,
  ffmpeg-headless,
  freetype,
  libjpeg_turbo,
  libpng,
  libmad,
  faad2,
  libogg,
  libvorbis,
  libtheora,
  a52dec,
  nghttp2,
  openjpeg,
  libcaca,
  mesa_glu,
  xvidcore,
  openssl,
  jack2,
  alsa-lib,
  pulseaudio,
  SDL2,
  curl,
  libxv,
  libx11,
  xorgproto,

  withFullDeps ? false,
  withFfmpeg ? withFullDeps,
  releaseChannel ? "stable",
}:

let
  stable = rec {
    version = "26.07.0";
    src = fetchFromGitHub {
      owner = "gpac";
      repo = "gpac";
      rev = "v${version}";
      hash = "sha256-L4GKXCFsKVxWXZJJeiAegXJySoS9+/V+/cuzEJEse+I=";
    };
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = "^(abi|test)";
    };
  };
  unstable = {
    version = "26.07.0-unstable-2026-08-30";
    src = fetchFromGitHub {
      owner = "gpac";
      repo = "gpac";
      rev = "c1a7cf55f59ef7954939c44f6b24b95c54469214";
      hash = "sha256-xO+UWeV/vRypfCfiPnlTPCznPturmakwoe+SeME7MJU=";
    };
    updateScript = unstableGitUpdater {
      tagFormat = "v*";
      tagPrefix = "v";
    };
  };
  channelToUse = if releaseChannel == "unstable" then unstable else stable;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gpac";
  inherit (channelToUse) version src;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ]
  ++ lib.optionals withFfmpeg [
    ffmpeg-headless
  ];

  # ref: https://wiki.gpac.io/Build/build/GPAC-Build-Guide-for-Linux/#gpac-easy-build-recommended-for-most-users
  buildInputs = [
    zlib
  ]
  ++ lib.optionals withFullDeps [
    freetype
    libjpeg_turbo
    libpng
    libmad
    faad2
    libogg
    libvorbis
    libtheora
    a52dec
    nghttp2
    openjpeg
    libcaca
    libx11
    libxv
    xorgproto
    mesa_glu
    xvidcore
    openssl
    jack2
    alsa-lib
    pulseaudio
    SDL2
    curl
  ];

  enableParallelBuilding = true;

  passthru.updateScript = channelToUse.updateScript;

  meta = {
    description = "Open Source multimedia framework for research and academic purposes";
    longDescription = ''
      GPAC is an Open Source multimedia framework for research and academic purposes.
      The project covers different aspects of multimedia, with a focus on presentation
      technologies (graphics, animation and interactivity) and on multimedia packaging
      formats such as MP4.

      GPAC provides three sets of tools based on a core library called libgpac:

      A multimedia player, called Osmo4 / MP4Client,
      A multimedia packager, called MP4Box,
      And some server tools included in MP4Box and MP42TS applications.
    '';
    homepage = "https://gpac.wp.imt.fr";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      mgdelacroix
      thesn
    ];
    platforms = lib.platforms.unix;
  };
})
