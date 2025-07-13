{
  lib,
  stdenv,
  fetchFromGitHub,
  cctools,
  pkg-config,
  zlib,
  ffmpeg,
  freetype,
  libjpeg,
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
  libXv,
  mesa,
  mesa_glu,
  xvidcore,
  openssl,
  jack2,
  alsa-lib,
  pulseaudio,
  SDL2,
  curl,

  withFullDeps ? false,
  withFfmpeg ? withFullDeps,
  releaseChannel ? "stable",
}:

stdenv.mkDerivation rec {
  pname = "gpac";
  version = if releaseChannel == "nightly" then "2.4-unstable-2025-07-11" else "2.4.0";

  src =
    if releaseChannel == "nightly" then
      fetchFromGitHub {
        owner = "gpac";
        repo = "gpac";
        rev = "fe88c3545aadd597b250ccf23271d5d3de50ccc8";
        hash = "sha256-c6B9Y19ZZ3PLz82GCcjkWzcUQSEK7ufVNEzqHQqOvrI=";
      }
    else
      fetchFromGitHub {
        owner = "gpac";
        repo = "gpac";
        rev = "v${version}";
        hash = "sha256-RADDqc5RxNV2EfRTzJP/yz66p0riyn81zvwU3r9xncM=";
      };

  nativeBuildInputs =
    [
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
    ]
    ++ lib.optionals withFfmpeg [
      ffmpeg
    ];

  # ref: https://wiki.gpac.io/Build/build/GPAC-Build-Guide-for-Linux/#gpac-easy-build-recommended-for-most-users
  buildInputs = [
    zlib
  ]
  ++ lib.optionals withFullDeps [
    freetype
    libjpeg
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
    libXv
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
}
