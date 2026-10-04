{
  addDriverRunpath,
  alsa-lib,
  clangStdenv,
  copyDesktopItems,
  cctools,
  fetchFromGitHub,
  fetchgit,
  flite,
  fontconfig,
  gn,
  jdk21,
  jdk25,
  lib,
  libGL,
  libjack2,
  libpulseaudio,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  linkFarm,
  makeDesktopItem,
  makeWrapper,
  ninja,
  nix-update-script,
  openal,
  pipewire,
  pkg-config,
  python3,
  rcodesign,
  removeReferencesTo,
  runCommand,
  rustPlatform,
  stdenv,
  wayland,

  additionalLibs ? [ ],
  jdks ? [
    jdk25
    jdk21
  ],
  textToSpeechSupport ? stdenv.hostPlatform.isLinux,
}:

assert lib.assertMsg (
  textToSpeechSupport -> stdenv.hostPlatform.isLinux
) "textToSpeechSupport only has an effect on Linux.";

let
  infoPlist =
    version:
    lib.generators.toPlist { escape = true; } {
      CFBundleDevelopmentRegion = "en";
      CFBundleDisplayName = "OneClient";
      CFBundleExecutable = "oneclient_app";
      CFBundleIconFile = "icon.icns";
      CFBundleIdentifier = "org.polyfrost.OneClient";
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundleName = "OneClient";
      CFBundlePackageType = "APPL";
      CFBundleShortVersionString = version;
      CFBundleSupportedPlatforms = [ "MacOSX" ];
      CFBundleVersion = version;

      LSEnvironment = {
        ONECLIENT_DISABLE_AUTOUPDATE = "1";
      };

      LSApplicationCategoryType = "public.app-category.games";
      LSMinimumSystemVersion = "10.14";
      NSHighResolutionCapable = true;

      CFBundleURLTypes = [
        {
          CFBundleURLName = "OneClient";
          CFBundleURLSchemes = [ "oneclient" ];
        }
      ];

      NSCameraUsageDescription = "A Minecraft mod is requesting access to your camera.";
      NSMicrophoneUsageDescription = "A Minecraft mod is requesting access to your microphone.";
    };
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "oneclient";
  version = "2.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Polyfrost";
    repo = "OneLauncher";
    tag = "oneclient-${finalAttrs.version}";
    hash = "sha256-OMwbPJBLJo1yCRQD+ZWJoWpWxuCP2/7C/djE/vcRdOY=";
  };

  cargoHash = "sha256-m++q3uiAvNXloA0fHLweCO9FMPtaGZblLhqR5ZCqLKQ=";

  env = {
    SKIA_SOURCE_DIR =
      let
        repo = fetchFromGitHub {
          owner = "rust-skia";
          repo = "skia";
          # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
          tag = "m148-0.97.0";
          hash = "sha256-uFnYX6ZDg+cJwLyCe6IGB6M3aCyI/+q2aYP4JfHm544=";
        };
        # The externals for skia are taken from skia/DEPS
        externals = linkFarm "skia-externals" (
          lib.mapAttrsToList (name: value: {
            inherit name;
            path = fetchgit value;
          }) (lib.importJSON ./skia-externals.json)
        );
      in
      runCommand "source" { } ''
        cp -R ${repo} $out
        chmod -R +w $out
        ln -s ${externals} $out/third_party/externals
      '';

    SKIA_GN_COMMAND = lib.getExe gn;
    SKIA_NINJA_COMMAND = lib.getExe ninja;
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3
    removeReferencesTo
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
    rcodesign
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    fontconfig
    libGL
    wayland
  ];

  cargoBuildFlags = [
    "--package"
    "oneclient_app"
  ];

  cargoTestFlags = [
    "--package"
    "oneclient_app"
  ];

  disallowedReferences = [ finalAttrs.env.SKIA_SOURCE_DIR ];

  postInstall = ''
    # Skia embeds the path to its sources
    remove-references-to -t "$SKIA_SOURCE_DIR" \
      $out/bin/oneclient_app
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    app="$out/Applications/OneClient.app"
    mkdir -p "$app/Contents/"{MacOS,Resources}

    mv "$out/bin/oneclient_app" "$app/Contents/MacOS/oneclient_app"
    makeWrapper "$app/Contents/MacOS/oneclient_app" "$out/bin/oneclient_app" \
      --set ONECLIENT_DISABLE_AUTOUPDATE 1

    printf '%s' ${lib.escapeShellArg (infoPlist finalAttrs.version)} > "$app/Contents/Info.plist"
    printf 'APPL????' > "$app/Contents/PkgInfo"

    install -m444 packages/oneclient_app/icons/icon.icns \
      "$app/Contents/Resources/icon.icns"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    for size in 32x32 64x64 128x128 512x512; do
      install -Dm444 "packages/oneclient_app/icons/$size.png" \
        "$out/share/icons/hicolor/$size/apps/oneclient_app.png"
    done
  '';

  postFixup =
    let
      libPath = lib.makeLibraryPath (
        [
          fontconfig
          (lib.getLib stdenv.cc.cc)

          # openal
          openal
          alsa-lib
          libjack2
          libpulseaudio
          pipewire

          # glfw
          libGL
          libx11
          libxcb
          libxcursor
          libxi
          libxkbcommon
          libxrandr
          wayland
        ]
        ++ lib.optional textToSpeechSupport flite
        ++ additionalLibs
      );
    in
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      ${lib.getExe rcodesign} sign \
        --code-signature-flags runtime \
        --entitlements-xml-file ${finalAttrs.src}/packages/oneclient_app/distribution/App.entitlements \
        "$out/Applications/OneClient.app"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram "$out/bin/oneclient_app" \
        --set ONECLIENT_DISABLE_AUTOUPDATE 1 \
        --set LD_LIBRARY_PATH "${addDriverRunpath.driverLink}/lib:${libPath}" \
        --prefix PATH : "${lib.makeBinPath jdks}"
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "oneclient_app";
      desktopName = "OneClient";
      comment = "Next-generation open source Minecraft launcher";
      exec = "oneclient_app";
      icon = "oneclient_app";
      terminal = false;
      startupNotify = true;
      startupWMClass = "oneclient_app";
      categories = [
        "Game"
        "ActionGame"
        "AdventureGame"
        "Simulation"
      ];
      keywords = [
        "mc"
        "minecraft"
        "game"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next-generation open source Minecraft launcher";
    homepage = "https://polyfrost.org/projects/oneclient";
    license = lib.licenses.gpl3Only;
    mainProgram = "oneclient_app";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ saadndm ];
  };
})
