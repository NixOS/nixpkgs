{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libpng,
  zlib,
  xz,
  curl,

  # Linux-only graphics/font stack (OpenTTD uses Cocoa/CoreText on Darwin)
  SDL2,
  freetype,
  fontconfig,
  icu,
  harfbuzz,
  expat,
  glib,
  pcre2,
  withOpenGFX ? true,
  withOpenSFX ? true,
  withOpenMSX ? true,

  # FluidSynth is unused on Darwin (CoreMIDI handles music there)
  withFluidSynth ? !stdenv.hostPlatform.isDarwin,
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
  apple-sdk,
  makeWrapper,
  buildPackages,
  callPackage,
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
    libpng
    xz
    zlib
    curl
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    SDL2
    freetype
    fontconfig
    icu
    harfbuzz
    expat
    glib
    pcre2
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk
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

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # macOS defaults OPTION_INSTALL_FHS to OFF (for .app bundle builds), but
    # nixpkgs installs to the Nix store which needs a standard FHS layout so
    # that all data lands under $out/share/games/openttd/ before we symlink
    # it into the bundle's Contents/Resources/.
    (lib.cmakeBool "OPTION_INSTALL_FHS" true)
  ];

  postPatch = ''
    printf '${finalAttrs.version}\t20250101\t0\t\t1\t1' > .ottdrev
  ''
  + lib.optionalString withFluidSynth ''
    substituteInPlace src/music/fluidsynth.cpp \
      --replace-fail "/usr/share/soundfonts/default.sf2" \
                     "${soundfont-fluid}/share/soundfonts/${soundfont-name}.sf2"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # PackageBundle.cmake unconditionally installs a fixup_bundle() rule that
      # expects a .app bundle at $CMAKE_INSTALL_PREFIX/../MacOS/openttd.  With
      # OPTION_INSTALL_FHS=ON we install to a standard FHS tree, so there is no bundle :(
      substituteInPlace cmake/InstallAndPackage.cmake \
        --replace-fail \
          'include(PackageBundle)' \
          'if(NOT OPTION_INSTALL_FHS)
      include(PackageBundle)
    endif()'
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
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      APP="$out/Applications/OpenTTD.app/Contents"
      mkdir -p "$APP/MacOS" "$APP/Resources"

      mv "$out/bin/openttd" "$APP/MacOS/openttd"
      ln -s "../Applications/OpenTTD.app/Contents/MacOS/openttd" "$out/bin/openttd"

      # Expose FHS data through Resources so CFBundle-based path lookup finds it.
      for d in lang baseset ai game scripts; do
        ln -s "$out/share/games/openttd/$d" "$APP/Resources/$d"
      done

      cp "$src/os/macosx/openttd.icns" "$APP/Resources/OpenTTD.icns"

      cp "$src/os/macosx/Info.plist.in" "$APP/Info.plist"
      substituteInPlace "$APP/Info.plist" \
        --replace-fail $'\x24{CPACK_BUNDLE_NAME}' 'OpenTTD' \
        --replace-fail '#CPACK_PACKAGE_VERSION#' '${finalAttrs.version}' \
        --replace-fail $'\x24{CURRENT_YEAR}' '2025'
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
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      jcumming
      fpletz
      philocalyst
    ];
  };
})
