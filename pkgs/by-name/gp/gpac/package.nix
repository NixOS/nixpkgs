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
  mesa,
  mesa_glu,
  xvidcore,
  openssl,
  jack2,
  alsa-lib,
  pulseaudio,
  SDL2,
  curl,
  xorg,

  withFullDeps ? false,
  withFfmpeg ? withFullDeps,
  releaseChannel ? "stable",
}:

let
  stable = rec {
    version = "2.4.0"; # See below TODO.
    src = fetchFromGitHub {
      owner = "gpac";
      repo = "gpac";
      rev = "v${version}";
      hash = "sha256-RADDqc5RxNV2EfRTzJP/yz66p0riyn81zvwU3r9xncM=";
    };
    updateScript = gitUpdater {
      odd-unstable = true;
      rev-prefix = "v";
      ignoredVersions = "^(abi|test)";
    };
  }
  // {
    # ffmpeg 7.0.2 works, but 7.1.1 (which is packaged in nixpkgs) doesn't
    # because v2.4.0 of this package relies on internal private ffmpeg fields.
    # TODO: remove this, and switch to simply using ffmpeg-headless,
    #       when updating stable to 2.6
    ffmpeg-headless = ffmpeg-headless.override {
      version = "7.0.2";
      hash = "sha256-6bcTxMt0rH/Nso3X7zhrFNkkmWYtxsbUqVQKh25R1Fs=";
    };
  };
  unstable = {
    version = "2.4-unstable-2025-10-26";
    src = fetchFromGitHub {
      owner = "gpac";
      repo = "gpac";
      rev = "e1a54e81b3befba2b0bffd1d4c1cf50da516c5f3";
      hash = "sha256-jSMBPuWPmTDCebImdmAcCZl0hEQpJK4QMNGcEXgs3A4=";
    };
    updateScript = unstableGitUpdater {
      tagFormat = "v*";
      tagPrefix = "v";
    };
    inherit ffmpeg-headless;
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
    channelToUse.ffmpeg-headless
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
    xorg.libX11
    xorg.libXv
    xorg.xorgproto
    mesa
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
