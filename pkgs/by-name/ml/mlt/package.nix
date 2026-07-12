{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  which,
  ffmpeg,
  fftw,
  frei0r,
  libdv,
  libjack2,
  libsamplerate,
  libvorbis,
  libxml2,
  libx11,
  makeWrapper,
  movit,
  opencv4,
  rtaudio,
  rubberband,
  sox,
  vid-stab,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  enableJackrack ? stdenv.hostPlatform.isLinux,
  gdk-pixbuf,
  glib,
  ladspa-sdk,
  ladspaPlugins,
  enablePython ? false,
  python3,
  swig,
  qtbase ? null,
  wrapQtAppsHook ? null,
  qtsvg ? null,
  qt5compat ? null,
  enableSDL2 ? true,
  SDL2,
  gitUpdater,
  libarchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mlt";
  version = "7.38.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tZWkgDffNZwJgfrFQNKfS+QzpcjaM0SEBbyxrVBqubc=";
    # The submodule contains glaxnimate code, since MLT uses internally some functions defined in glaxnimate.
    # Since glaxnimate is not available as a library upstream, we cannot remove for now this dependency on
    # submodules until upstream exports glaxnimate as a library: https://gitlab.com/mattbas/glaxnimate/-/issues/545
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    makeWrapper
    wrapQtAppsHook
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ]
  ++ lib.optionals enablePython [
    python3
    swig
  ];

  buildInputs = [
    gdk-pixbuf
    (opencv4.override { ffmpeg-headless = ffmpeg; })
    ffmpeg
    fftw
    frei0r
    libdv
    libjack2
    libsamplerate
    libvorbis
    libxml2
    movit
    rtaudio
    rubberband
    sox
    vid-stab
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ]
  ++ lib.optionals enableJackrack [
    glib
    ladspa-sdk
    ladspaPlugins
  ]
  ++ lib.optionals (qtbase != null) [
    qtbase
    qtsvg
    qt5compat
    libarchive
  ]
  ++ lib.optionals enableSDL2 [
    SDL2
    libx11
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    (lib.cmakeBool "MOD_OPENCV" true)
    (lib.cmakeBool "MOD_QT6" (qtbase != null && lib.versions.major qtbase.version == "6"))
    (lib.cmakeBool "MOD_GLAXNIMATE_QT6" (qtbase != null && lib.versions.major qtbase.version == "6"))
  ]
  ++ lib.optionals enablePython [
    (lib.cmakeBool "SWIG_PYTHON" true)
  ];

  preFixup = ''
    wrapProgram $out/bin/melt \
      --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1 \
      ${lib.optionalString enableJackrack "--prefix LADSPA_PATH : ${ladspaPlugins}/lib/ladspa"} \
      ${lib.optionalString (qtbase != null) "\${qtWrapperArgs[@]}"}

  '';

  postFixup = ''
    substituteInPlace "$dev"/lib/pkgconfig/mlt-framework-7.pc \
      --replace '=''${prefix}//' '=/'
  '';

  passthru = {
    inherit ffmpeg;
  };

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = "https://www.mltframework.org/";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [
      nick-linux
    ];
    platforms = lib.platforms.unix;
  };
})
