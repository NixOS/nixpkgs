{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
  cmake,
  pkg-config,
  SDL2,
  libpng,
  zlib,
  xz,
  freetype,
  fontconfig,
  curl,
  icu,
  harfbuzz,
  expat,
  glib,
  pcre2,
  withOpenGFX ? true,
  withOpenSFX ? true,
  withOpenMSX ? true,
  withFluidSynth ? true,
  fluidsynth,
  soundfont-fluid,
  soundfont-name ? "FluidR3_GM2-2",
  libsndfile,
  flac,
  libogg,
  libvorbis,
  libopus,
  libmpg123,
  pulseaudio,
  alsa-lib,
  libjack2,
  makeWrapper,
  buildPackages,
  versionCheckHook,
}:

let
  opengfx = callPackage ./opengfx.nix { };
  opensfx = callPackage ./opensfx.nix { };
  openmsx = callPackage ./openmsx.nix { };

  # OpenTTD builds and uses some of its own tools during the build and we need those to be available for cross-compilation.
  # Build the tools for buildPlatform with minimal dependencies, using the "OPTION_TOOLS_ONLY" flag.
  crossTools = buildPackages.openttd.overrideAttrs (oldAttrs: {
    pname = "openttd-tools";
    buildInputs = [ ];
    cmakeFlags = oldAttrs.cmakeFlags or [ ] ++ [ (lib.cmakeBool "OPTION_TOOLS_ONLY" true) ];
    installPhase = ''
      install -Dm555 src/strgen/strgen -t $out/bin
      install -Dm555 src/settingsgen/settingsgen -t $out/bin
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openttd";
  version = "15.3";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "OpenTTD";
    tag = finalAttrs.version;
    hash = "sha256-KVOCFZaSmdmG270YEcJpGe6AjqAKpYNhkv9IjXxmrM8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    crossTools
  ];

  buildInputs = [
    SDL2
    libpng
    xz
    zlib
    freetype
    fontconfig
    curl
    icu
    harfbuzz
    expat
    glib
    pcre2
  ]
  ++ lib.optionals withFluidSynth [
    fluidsynth
    soundfont-fluid
    libsndfile
    flac
    libogg
    libvorbis
    libopus
    libmpg123
    pulseaudio
    alsa-lib
    libjack2
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  strictDeps = true;

  postPatch = ''
    substituteInPlace src/music/fluidsynth.cpp \
      --replace-fail "/usr/share/soundfonts/default.sf2" \
                     "${soundfont-fluid}/share/soundfonts/${soundfont-name}.sf2"
  '';

  postInstall =
    lib.optionalString withOpenGFX ''
      cp ${opengfx}/*.tar $out/share/games/openttd/baseset
    ''
    + lib.optionalString withOpenSFX ''
      cp ${opensfx}/*.tar $out/share/games/openttd/baseset
    ''
    + lib.optionalString withOpenMSX ''
      tar -xf ${openmsx}/*.tar -C $out/share/games/openttd/baseset
    '';

  meta = {
    description = ''Open source clone of the Microprose game "Transport Tycoon Deluxe"'';
    mainProgram = "openttd";
    longDescription = ''
      OpenTTD is a transportation economics simulator. In single player mode,
      players control a transportation business, and use rail, road, sea, and air
      transport to move goods and people around the simulated world.

      In multiplayer networked mode, players may:
        - play competitively as different businesses
        - play cooperatively controlling the same business
        - observe as spectators
    '';
    homepage = "https://www.openttd.org/";
    changelog = "https://cdn.openttd.org/openttd-releases/${finalAttrs.version}/changelog.md";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jcumming
      fpletz
      philocalyst
    ];
  };
})
