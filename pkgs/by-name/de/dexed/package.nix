{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  pkg-config,
  libX11,
  libXrandr,
  libXinerama,
  libXext,
  libXcursor,
  freetype,
  alsa-lib,
  libjack2,
  apple-sdk_11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dexed";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "asb2m10";
    repo = "dexed";
    rev = "refs/tags/v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-mXr1KGzA+DF2dEgAJE4lpnefPqO8pqfnKa43vyjSJgU=";
  };

  postPatch =
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE INTERNAL "")' '# Not forcing output archs'

      substituteInPlace Source/CMakeLists.txt \
        --replace-fail 'COPY_PLUGIN_AFTER_BUILD TRUE' 'COPY_PLUGIN_AFTER_BUILD FALSE'
    ''
    # LTO needs special setup on Linux
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace Source/CMakeLists.txt \
        --replace-fail 'juce::juce_recommended_lto_flags' '# Not forcing LTO'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      libX11
      libXext
      libXcursor
      libXinerama
      libXrandr
      freetype
      alsa-lib
      libjack2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  # JUCE insists on only dlopen'ing these
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux (toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
    "-ljack"
  ]);

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
