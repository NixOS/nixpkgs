{
  lib,
  stdenvNoCC,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  makeBinaryWrapper,
  ffmpeg,
  SDL2,
  sdl3,
  libglvnd,
  vulkan-loader,
  nix-update-script,
  icnsify,
  nativeWayland ? false,

  # Linux-only dependencies
  lttng-ust,
  alsa-lib,
  numactl,
  libxi,
  udev,
}:

buildDotnetModule (finalAttrs: {
  pname = "osu-lazer";
  version = "2026.804.2";

  src = fetchFromGitHub {
    owner = "ppy";
    repo = "osu";
    tag = "${finalAttrs.version}-lazer";
    hash = "sha256-1cUR3Z3TCNfnkyNkxlb+rmsFkYZ0WMBBRQwvRqoXUfw=";
  };

  projectFile = "osu.Desktop/osu.Desktop.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
    copyDesktopItems
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    icnsify
    makeBinaryWrapper
  ];

  runtimeDeps = [
    ffmpeg
    SDL2
    sdl3
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
    lttng-ust
    numactl
    alsa-lib

    # needed to avoid:
    # Failed to create SDL window. SDL Error: Could not initialize OpenGL / GLES library
    libglvnd

    # needed for the window to actually appear
    libxi

    # needed to avoid in runtime.log:
    # [verbose]: SDL error log [debug]: Failed loading udev_device_get_action: /nix/store/*-osu-lazer-*/lib/osu-lazer/runtimes/linux-x64/native/libSDL2.so: undefined symbol: _udev_device_get_action
    # [verbose]: SDL error log [debug]: Failed loading libudev.so.1: libudev.so.1: cannot open shared object file: No such file or directory
    udev

    # needed for vulkan renderer, can fall back to opengl if omitted
    vulkan-loader
  ];

  executables = [ "osu!" ];

  fixupPhase = ''
    runHook preFixup

    # OSU_EXTERNAL_UPDATE_PROVIDER prevents osu from rewriting itself on update (nix manages upgrades)
    wrapProgram $out/bin/osu! \
      ${
        lib.optionalString (
          nativeWayland && stdenvNoCC.hostPlatform.isLinux
        ) "--set SDL_VIDEODRIVER wayland"
      } \
      --set OSU_EXTERNAL_UPDATE_PROVIDER 1

    ${lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      for i in 16 32 48 64 96 128 256 512 1024; do
        install -D ./assets/lazer.png $out/share/icons/hicolor/''${i}x$i/apps/osu.png
      done

      ln -sft $out/lib/${finalAttrs.pname} ${SDL2}/lib/libSDL2${stdenvNoCC.hostPlatform.extensions.sharedLibrary}
      ln -sft $out/lib/${finalAttrs.pname} ${sdl3}/lib/libSDL3${stdenvNoCC.hostPlatform.extensions.sharedLibrary}
    ''}

    ${lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
      OSU_CONTENTS="$out/Applications/osu!.app/Contents"
      mkdir -p "$OSU_CONTENTS/MacOS" "$OSU_CONTENTS/Resources"

      # Move game in but keep a symlink so $out/bin/osu! still resolves
      mv "$out/lib/osu-lazer" "$OSU_CONTENTS/Frameworks"
      ln -s "$OSU_CONTENTS/Frameworks" "$out/lib/osu-lazer"

      # Generate a proper macOS Info.plist (osu.iOS/Info.plist is iOS-only with LSRequiresIPhoneOS)
      cat > "$OSU_CONTENTS/Info.plist" <<EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0"><dict>
        <key>CFBundleName</key><string>osu!</string>
        <key>CFBundleDisplayName</key><string>osu!</string>
        <key>CFBundleIdentifier</key><string>sh.ppy.osu.lazer</string>
        <key>CFBundleVersion</key><string>${finalAttrs.version}</string>
        <key>CFBundleShortVersionString</key><string>${finalAttrs.version}</string>
        <key>CFBundlePackageType</key><string>APPL</string>
        <key>CFBundleSignature</key><string>????</string>
        <key>CFBundleExecutable</key><string>osu!</string>
        <key>CFBundleIconFile</key><string>AppIcon</string>
        <key>NSHighResolutionCapable</key><true/>
        <key>LSMinimumSystemVersion</key><string>11.0</string>
        <key>CFBundleDocumentTypes</key><array>
          <dict>
            <key>CFBundleTypeName</key><string>osu! beatmap</string>
            <key>CFBundleTypeExtensions</key><array><string>osz</string><string>osk</string></array>
            <key>CFBundleTypeRole</key><string>Viewer</string>
            <key>LSHandlerRank</key><string>Owner</string>
          </dict>
          <dict>
            <key>CFBundleTypeName</key><string>osu! replay</string>
            <key>CFBundleTypeExtensions</key><array><string>osr</string></array>
            <key>CFBundleTypeRole</key><string>Viewer</string>
            <key>LSHandlerRank</key><string>Owner</string>
          </dict>
        </array>
        <key>CFBundleURLTypes</key><array>
          <dict><key>CFBundleURLSchemes</key><array><string>osu</string><string>osump</string></array><key>CFBundleTypeRole</key><string>Editor</string></dict>
        </array>
      </dict></plist>
      EOF

      icnsify ./assets/lazer.png --output "$OSU_CONTENTS/Resources/AppIcon.icns"

      # Launch Services refuses to run an app whose executable is a symlink into the Nix store
      makeBinaryWrapper "$out/bin/osu!" "$OSU_CONTENTS/MacOS/osu!"
    ''}

    runHook postFixup
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "osu!";
      name = "osu";
      exec = "osu!";
      icon = "osu";
      comment = "Rhythm is just a *click* away (no score submission or multiplayer, see osu-lazer-bin)";
      type = "Application";
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=(.*)-lazer"
    ];
  };

  meta = {
    description = "Rhythm is just a *click* away (no score submission or multiplayer, see osu-lazer-bin)";
    homepage = "https://osu.ppy.sh";
    changelog = "https://osu.ppy.sh/home/changelog/lazer/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    maintainers = with lib.maintainers; [
      gepbird
      thiagokokada
      Guanran928
      philocalyst
    ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "osu!";
  };
})
