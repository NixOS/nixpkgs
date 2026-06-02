{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
    version = "26.02.0";
    src = fetchFromGitHub {
      owner = "gpac";
      repo = "gpac";
      rev = "v${version}";
      hash = "sha256-UtL+KG3dsp6dD7cfTK7e17ngt/RHKJL0s5IopTM3VOk=";
    };
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = "^(abi|test)";
    };
  };
  unstable = {
    version = "26.02.0-unstable-2026-04-29";
    src = fetchFromGitHub {
      owner = "gpac";
      repo = "gpac";
      rev = "525bf1af642c30af04e4df5345e6d798c0a4d8a1";
      hash = "sha256-G/4gefsS2hUKo8VEt80YZOaGJSjrzXFrdHO/u33BiDw=";
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

  patches = lib.optionals (releaseChannel == "stable") [
    (fetchpatch2 {
      # CVE-2026-7135 fix
      url = "https://github.com/gpac/gpac/commit/cf6ac48c972eaaee2af270adc3f36615325deb3e.patch?full_index=1";
      hash = "sha256-JaJiQAQvzdB74ag2/aZTiQa2NqlgqgMYS1tsk/R+wiI=";
    })
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
