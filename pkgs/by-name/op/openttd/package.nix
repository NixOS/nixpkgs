{
  lib,
  stdenv,
  fetchzip,
  SDL2,
  buildPackages,
  cmake,
  curl,
  fluidsynth,
  fontconfig,
  freetype,
  harfbuzz,
  icu,
  libGL,
  libogg,
  libopus,
  libpng,
  lzo,
  opusfile,
  pkg-config,
  soundfont-fluid,
  versionCheckHook,
  xz,
  zlib,
  soundfont-name ? "FluidR3_GM2-2",
  withFluidSynth ? true,
  withOpenGFX ? true,
  withOpenMSX ? true,
  withOpenSFX ? true,
}:

let
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
    doInstallCheck = false;
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openttd";
  version = "15.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://cdn.openttd.org/openttd-releases/${finalAttrs.version}/openttd-${finalAttrs.version}-source.tar.xz";
    hash = "sha256-xDpDEeWdAWMyA/I+ioQR98vwrL9WXYd5AjswJ4NuVMY=";
  };

  postPatch = lib.optionalString withFluidSynth ''
    substituteInPlace src/music/fluidsynth.cpp \
      --replace-fail "/usr/share/soundfonts/default.sf2" \
                     "${soundfont-fluid}/share/soundfonts/${soundfont-name}.sf2"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    crossTools
  ];

  buildInputs = [
    SDL2
    curl
    fontconfig
    freetype
    harfbuzz
    icu
    libGL
    libogg
    libopus
    libpng
    lzo
    opusfile
    xz
    zlib
  ]
  ++ lib.optional withFluidSynth fluidsynth;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall =
    lib.optionalString withOpenGFX ''
      cp ${finalAttrs.assets.opengfx}/*.tar $out/share/games/openttd/baseset
    ''
    + lib.optionalString withOpenSFX ''
      cp ${finalAttrs.assets.opensfx}/*.tar $out/share/games/openttd/baseset
    ''
    + lib.optionalString withOpenMSX ''
      tar -xf ${finalAttrs.assets.openmsx}/*.tar -C $out/share/games/openttd/baseset
    '';

  assets = {
    opengfx = fetchzip {
      url = "https://cdn.openttd.org/opengfx-releases/${finalAttrs.opengfxVersion}/opengfx-${finalAttrs.opengfxVersion}-all.zip";
      hash = "sha256-aqLEZ3EptxBZrYQd1IG6B1rSRJJTGIijKu2NIqpAYRA=";
    };
    openmsx = fetchzip {
      url = "https://cdn.openttd.org/openmsx-releases/${finalAttrs.openmsxVersion}/openmsx-${finalAttrs.openmsxVersion}-all.zip";
      hash = "sha256-ysNFIvo7iaLN8XoaeZuZQFLpBZlYUDLDg7rH6TabaHY=";
    };
    opensfx = fetchzip {
      url = "https://cdn.openttd.org/opensfx-releases/${finalAttrs.opensfxVersion}/opensfx-${finalAttrs.opensfxVersion}-all.zip";
      hash = "sha256-QmfXizrRTu/fUcVOY7tCndv4t4BVW+fb0yUi8LgSYzM=";
    };
  };

  opengfxVersion = "8.0";
  openmsxVersion = "0.4.2";
  opensfxVersion = "1.0.3";

  passthru.updateScript = ./update.sh;

  meta = {
    description = ''Open source clone of the Microprose game "Transport Tycoon Deluxe"'';
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
    maintainers = with lib.maintainers; [
      jcumming
      fpletz
    ];
    platforms = lib.platforms.linux;
    mainProgram = "openttd";
    downloadPage = "https://www.openttd.org/downloads/openttd-releases/latest";
  };
})
