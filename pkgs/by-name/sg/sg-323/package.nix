{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  fontconfig,
  freetype,
  libx11,
  libxcomposite,
  libxcursor,
  libxdmcp,
  libxext,
  libxinerama,
  libxrandr,
  libxtst,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SG-323";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "greyboxaudio";
    repo = "SG-323";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-yAC4YQt8f5kQ03ECAxvoM9wcqna98F4XKcwUQg6l4E0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
  ]
  ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libx11
    libxcomposite
    libxcursor
    libxdmcp
    libxext
    libxinerama
    libxrandr
    libxtst
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux (toString [
    # juce, compiled in this build as part of a Git submodule, uses `-flto` as
    # a Link Time Optimization flag, and instructs the plugin compiled here to
    # use this flag to. This breaks the build for us. Using _fat_ LTO allows
    # successful linking while still providing LTO benefits. If our build of
    # `juce` was used as a dependency, we could have patched that `-flto` line
    # in our juce's source, but that is not possible because it is used as a
    # Git Submodule.
    "-ffat-lto-objects"
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
          mkdir -p ${auDir}
          cp -r "SG323_artefacts/Release/AU/SG-323.component" ${auDir}
        ''
      else
        ''
          mkdir -p $out/lib/lv2
          cp -r "SG323_artefacts/Release/LV2/SG-323.lv2" $out/lib/lv2
        ''
    )
    + ''
      mkdir -p ${vst3Dir} ${clapDir}
      mv SG323_artefacts/Release/VST3/* ${vst3Dir}
      mv SG323_artefacts/Release/CLAP/* ${clapDir}

      runHook postInstall
    '';

  meta = {
    description = "Ursa Major Stargate 323 reverb plugin";
    homepage = "https://github.com/greyboxaudio/SG-323";
    changelog = "https://github.com/greyboxaudio/SG-323/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.all;
  };
})
