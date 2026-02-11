{
  stdenv,
  fetchurl,
  cmake,
  dbus,
  fftwFloat,
  file,
  freetype,
  jansson,
  lib,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxrandr,
  libarchive,
  libjack2,
  liblo,
  libsamplerate,
  libsndfile,
  makeWrapper,
  pkg-config,
  python3,
  speexdsp,
  libglvnd,
  headless ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cardinal";
  version = "26.01";

  src = fetchurl {
    url = "https://github.com/DISTRHO/Cardinal/releases/download/${finalAttrs.version}/cardinal+deps-${finalAttrs.version}.tar.xz";
    hash = "sha256-KWQc+pcSMebP85yOtQ812qHAwaB6ZOvPpwsxG+myzDo=";
  };

  prePatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    file
    pkg-config
    makeWrapper
    python3
  ];

  buildInputs = [
    dbus
    fftwFloat
    freetype
    jansson
    libGL
    libx11
    libxcursor
    libxext
    libxrandr
    libarchive
    liblo
    libsamplerate
    libsndfile
    speexdsp
    libglvnd
  ];

  hardeningDisable = [ "format" ];
  makeFlags = [
    "SYSDEPS=true"
    "PREFIX=$(out)"
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "CROSS_COMPILING=true"
  ++ lib.optional headless "HEADLESS=true";

  postInstall = ''
    wrapProgram $out/bin/Cardinal \
    --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}

    wrapProgram $out/bin/CardinalMini \
    --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}

    # this doesn't work and is mainly just a test tool for the developers anyway.
    rm -f $out/bin/CardinalNative
  '';

  meta = {
    description = "Plugin wrapper around VCV Rack";
    homepage = "https://github.com/DISTRHO/cardinal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      magnetophon
      PowerUser64
    ];
    mainProgram = "Cardinal";
    platforms = lib.platforms.linux;
  };
})
