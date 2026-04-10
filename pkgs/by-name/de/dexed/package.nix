{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  pkg-config,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  freetype,
  alsa-lib,
  libjack2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dexed";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "asb2m10";
    repo = "dexed";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-9EbaME3kw2ptCWpaV9CnM0j5HOof264s5iFoOTcjwNg=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE INTERNAL "")' '# Not forcing output archs'

    substituteInPlace Source/CMakeLists.txt \
      --replace-fail 'COPY_PLUGIN_AFTER_BUILD TRUE' 'COPY_PLUGIN_AFTER_BUILD FALSE'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxext
    libxcursor
    libxinerama
    libxrandr
    freetype
    alsa-lib
    libjack2
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    # JUCE insists on only dlopen'ing these
    NIX_LDFLAGS = toString [
      "-lX11"
      "-lXext"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-ljack"
    ];
    NIX_CFLAGS_COMPILE = toString [
      # juce, compiled in this build as part of a Git submodule, uses `-flto` as
      # a Link Time Optimization flag, and instructs the plugin compiled here to
      # use this flag to. This breaks the build for us. Using _fat_ LTO allows
      # successful linking while still providing LTO benefits. If our build of
      # `juce` was used as a dependency, we could have patched that `-flto` line
      # in our juce's source, but that is not possible because it is used as a
      # Git Submodule.
      "-ffat-lto-objects"
    ];
  };

  installPhase =
    let
      vst3Dir =
        if stdenv.hostPlatform.isDarwin then "$out/Library/Audio/Plug-Ins/VST3" else "$out/lib/vst3";
      # this one's a guess, don't know where ppl have agreed to put them yet
      clapDir =
        if stdenv.hostPlatform.isDarwin then "$out/Library/Audio/Plug-Ins/CLAP" else "$out/lib/clap";
      auDir = "$out/Library/Audio/Plug-Ins/Components";
    in
    ''
      runHook preInstall

    ''
    + (
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/{Applications,bin}
          mv Source/Dexed_artefacts/Release/Standalone/Dexed.app $out/Applications/
          ln -s $out/{Applications/Dexed.app/Contents/MacOS,bin}/Dexed
        ''
      else
        ''
          install -Dm755 {Source/Dexed_artefacts/Release/Standalone,$out/bin}/Dexed
        ''
    )
    + ''
      mkdir -p ${vst3Dir} ${clapDir}
      mv Source/Dexed_artefacts/Release/VST3/* ${vst3Dir}
      mv Source/Dexed_artefacts/Release/CLAP/* ${clapDir}
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p ${auDir}
      mv Source/Dexed_artefacts/Release/AU/* ${auDir}
    ''
    + ''

      runHook postInstall
    '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "DX7 FM multi platform/multi format plugin";
    mainProgram = "Dexed";
    homepage = "https://asb2m10.github.io/dexed";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
})
