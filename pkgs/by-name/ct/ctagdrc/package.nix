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
  pname = "ctagdrc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "BillyDM";
    repo = "CTAGDRC";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-dJAmcoDhGoVG8h1T84qYhzEuvGdBVYQUuQC8mJkD4To=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    libx11
    libxcomposite
    libxcursor
    libxdmcp
    libxext
    libxinerama
    libxrandr
    libxtst
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # juce, compiled in this build as part of a Git submodule, uses `-flto` as
    # a Link Time Optimization flag, and instructs the plugin compiled here to
    # use this flag to. This breaks the build for us. Using _fat_ LTO allows
    # successful linking while still providing LTO benefits. If our build of
    # `juce` was used as a dependency, we could have patched that `-flto` line
    # in our juce's source, but that is not possible because it is used as a
    # Git Submodule.
    "-ffat-lto-objects"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
          --replace-fail 'COPY_PLUGIN_AFTER_BUILD TRUE' 'COPY_PLUGIN_AFTER_BUILD FALSE'
    substituteInPlace CMakeLists.txt \
          --replace-fail 'include(cmake-include/CPM.cmake)' '# No CPM needed'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/clap $out/lib/vst3
    install -Dm755 "CTAGDRC_artefacts/Release/Standalone/CTAGDRC" $out/bin/CTAGDRC
    install -Dm644 "CTAGDRC_artefacts/Release/CLAP/CTAGDRC.clap" -t $out/lib/clap
    cp -r "CTAGDRC_artefacts/Release/VST3/CTAGDRC.vst3" $out/lib/vst3

    runHook postInstall
  '';

  # JUCE dlopens these, make sure they are in rpath
  # Otherwise, segfault will happen
  env.NIX_LDFLAGS = toString [
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

  meta = {
    description = "Audio compressor plugin created with JUCE";
    homepage = "https://github.com/BillyDM/CTAGDRC";
    changelog = "https://github.com/BillyDM/CTAGDRC/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    mainProgram = "CTAGDRC";
    platforms = lib.platforms.all;
  };
})
