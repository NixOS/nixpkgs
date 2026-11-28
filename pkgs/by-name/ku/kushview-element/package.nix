{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  # Native Build Inputs
  autoPatchelfHook,
  cmake,
  ninja,
  pkg-config,

  # Build Inputs
  alsa-lib,
  boost,
  curl,
  fontconfig,
  freetype,
  libjack2,
  libx11,
  libxcomposite,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  libxrender,
}:
let
  # The nixpkgs' juce (8.0.12) and sol2 (3.5.0) are both older than the versions
  # requested here, so the find_package() calls fail and
  # we instead hand CMake
  # the pre-fetched trees via FETCHCONTENT_SOURCE_DIR_*.
  # Re-check both pins against those two cmake files on every version bump.
  juce-src = fetchFromGitHub {
    owner = "juce-framework";
    repo = "JUCE";
    tag = "8.0.13";
    hash = "sha256-TKqW2rsFMAO1HJZ9IFQ7myOzNRScqR0gmLSLQA5Sw28=";
  };

  # NOTE: Once nixpkgs contains 4.0.0 use this here.
  sol2-src = fetchFromGitHub {
    owner = "ThePhD";
    repo = "sol2";
    rev = "c1f95a773c6f8f4fde8ca3efe872e7286afe4444";
    hash = "sha256-0q0ew2ql0ED5ynYPQkq4UHq21VjiqSZTg09XsrrBwqI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kushview-element";
  version = "1.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "kushview";
    repo = "element";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-TQOPBXXo/08r8h9oocWCLHi1V7VlFF1D19hhhDc/HaQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    boost # headers only
    curl
    fontconfig
    freetype
    libjack2 # jack/weakjack.h; the library itself is dlopen'd
    libx11
    libxcomposite
    libxcursor
    libxext
    libxinerama
    libxrandr
    libxrender
  ];

  # autoPatchelfHook bakes these into the executable's RPATH.
  runtimeDependencies = [
    curl
    libjack2
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
    libxrender
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JUCE" "${juce-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SOL2" "${sol2-src}")
    # On by default upstream. The suites need a session bus, a display and a
    # working audio device, so they can't run in the sandbox.
    (lib.cmakeBool "ELEMENT_BUILD_TESTS" false)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modular audio plugin host";
    longDescription = ''
      Element is the community edition of Kushview's modular audio plugin host. It
      hosts LADSPA, LV2, VST3 and CLAP plugins, routes audio and MIDI between
      them on a patchbay-style graph, nests graphs within each other, and
      scripts both DSP and DSP UIs in Lua.
    '';
    homepage = "https://kushview.net/element";
    changelog = "https://github.com/kushview/element/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ gabyx ];
    mainProgram = "kushview-element";
    platforms = lib.platforms.linux;
  };
})
