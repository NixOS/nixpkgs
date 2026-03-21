{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  libjack2,
  libx11,
  libxext,
  libxcursor,
  libxinerama,
  libxrandr,
  libxrender,
}:

stdenv.mkDerivation rec {
  pname = "proteus";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "GuitarML";
    repo = "Proteus";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-WhJh+Sx64JYxQQ1LXpDUwXeodFU1EZ0TmMhn+6w0hQg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    freetype
    libjack2
    libx11
    libxext
    libxcursor
    libxinerama
    libxrandr
    libxrender
  ];

  postPatch = ''
    substituteInPlace modules/libsamplerate/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1..3.18)" "cmake_minimum_required(VERSION 3.18)"
    substituteInPlace modules/{json,RTNeural}/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  # JUCE loads most dependencies at runtime:
  runtimeDependencies = map lib.getLib buildInputs;

  env.NIX_CFLAGS_COMPILE = toString [
    # Support JACK output in the standalone application:
    "-DJUCE_JACK"
    # juce, compiled in this build as part of a Git submodule, uses `-flto` as
    # a Link Time Optimization flag, and instructs the plugin compiled here to
    # use this flag to. This breaks the build for us. Using _fat_ LTO allows
    # successful linking while still providing LTO benefits. If our build of
    # `juce` was used as a dependency, we could have patched that `-flto` line
    # in our juce's source, but that is not possible because it is used as a
    # Git Submodule.
    "-ffat-lto-objects"
  ];

  # The default "make install" only installs JUCE, which should not be installed, and does not install proteus.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -rT Proteus_artefacts/*/Standalone $out/bin
    cp -rT Proteus_artefacts/*/LV2 $out/lib/lv2
    cp -rT Proteus_artefacts/*/VST3 $out/lib/vst3

    runHook postInstall
  '';

  meta = {
    description = "Guitar amp and pedal capture plugin using neural networks";
    homepage = "https://github.com/GuitarML/Proteus";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "Proteus";
  };
}
