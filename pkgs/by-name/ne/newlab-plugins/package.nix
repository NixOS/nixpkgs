{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  fftwFloat,
  fontconfig,
  freetype,
  libGL,
  libx11,
  libxcomposite,
  libxcursor,
  libxdmcp,
  libxext,
  libxinerama,
  libxrandr,
  libxrender,
  libxtst,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

let
  # Upstream builds against its own forks of JUCE and nanovg (cloned by hand
  # into src/libs, see the README), so they are pinned here instead of using
  # the `juce` package.
  juce = fetchFromGitHub {
    owner = "nicolasdittlo";
    repo = "JUCE";
    rev = "99093e1490dc419b715461d7e5b8a3e5499754f2";
    hash = "sha256-rkx1OIrgLTmJuZT94LPoR8ErAh6vsHuS41pRlLJn7T4=";
  };
  nanovg = fetchFromGitHub {
    owner = "nicolasdittlo";
    repo = "nanovg";
    rev = "f93799c078fa11ed61c078c65a53914c8782c00b";
    hash = "sha256-eYHnyauoHLX5YIt2400D/9ZZwimb+KpoLOFFaF/vpsw=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "newlab-plugins";
  version = "0-unstable-2025-08-15";

  src = fetchFromGitHub {
    owner = "nicolasdittlo";
    repo = "newlab-plugins";
    rev = "9957c39cd672dd13bea0bee428ad8096f62e2d10";
    hash = "sha256-R5268gaHX8l9lzkJ1ONng2b589rKfdf7Ium+HoK/+64=";
  };

  # Upstream only ships Projucer (.jucer) projects. This adds a CMake build
  # mirroring their Linux export (VST3 + LV2; VST2 needs the proprietary SDK).
  patches = [ ./add-cmake.patch ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook # fontconfig cache
  ];

  buildInputs = [
    alsa-lib
    fftwFloat
    fontconfig
    freetype
    libGL
    libx11
    libxcomposite
    libxcursor
    libxdmcp
    libxext
    libxinerama
    libxrandr
    libxrender
    libxtst
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeFeature "JUCE_SRC_DIR" "${juce}")
    (lib.cmakeFeature "NANOVG_SRC_DIR" "${nanovg}")
  ];

  env = {
    # JUCE, built in-tree, passes `-flto` to the plugins; fat LTO objects
    # keep linking working (same workaround as the other JUCE plugins).
    NIX_CFLAGS_COMPILE = "-ffat-lto-objects";
    # JUCE dlopens these, make sure they are in the rpath.
    NIX_LDFLAGS = toString [
      "-lX11"
      "-lXext"
      "-lXcomposite"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-lXrender"
      "-lXtst"
      "-lXdmcp"
    ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3 $out/lib/lv2
    for plugin in BL_Air BL_Denoiser BL_STN; do
      cp -r "''${plugin}_artefacts/Release/VST3/''${plugin}.vst3" $out/lib/vst3
      cp -r "''${plugin}_artefacts/Release/LV2/''${plugin}.lv2" $out/lib/lv2
    done

    runHook postInstall
  '';

  # nix-update only bumps `src`; when it does, check whether the pinned
  # JUCE and nanovg forks above need to move as well (see the README).
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "BlueLab spectral audio plugins: denoiser, air extraction and sines/transients/noise separation";
    homepage = "https://www.bluelab-plugins.com";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
