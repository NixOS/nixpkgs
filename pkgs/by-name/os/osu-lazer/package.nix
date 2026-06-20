{
  lib,
  stdenvNoCC,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  ffmpeg,
  SDL2,
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
  version = "2026.518.0";

  src = fetchFromGitHub {
    owner = "ppy";
    repo = "osu";
    tag = "${finalAttrs.version}-lazer";
    hash = "sha256-ELtK5itKM7QIdVWzy3bHurp76AJvXA1a15OkYJgFcvU=";
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
  ];

  runtimeDeps = [
    ffmpeg
    SDL2
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
    ''}

    ${lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
      OSU_CONTENTS="$out/Applications/osu!.app/Contents"
      mkdir -p "$OSU_CONTENTS/MacOS" "$OSU_CONTENTS/Resources"

      # Move game in but keep a symlink so $out/bin/osu! still resolves
      mv "$out/lib/osu-lazer" "$OSU_CONTENTS/Frameworks"
      ln -s "$OSU_CONTENTS/Frameworks" "$out/lib/osu-lazer"

      install -Dm644 osu.iOS/Info.plist "$OSU_CONTENTS/Info.plist"
      substituteInPlace "$OSU_CONTENTS/Info.plist" \
        --replace-fail "sh.ppy.osulazer" "sh.ppy.osu.lazer" \
        --replace-fail "<key>CFBundleIdentifier</key>" "<key>CFBundleIconFile</key><string>AppIcon.icns</string><key>CFBundleExecutable</key><string>osu!</string><key>NSHighResolutionCapable</key><true/><key>CFBundleIdentifier</key>"

      icnsify ./assets/lazer.png --output "$OSU_CONTENTS/Resources/AppIcon.icns"

      # Symlink into the bundle so the app uses the same wrapper as $out/bin/osu!,
      ln -s "$out/bin/osu!" "$OSU_CONTENTS/MacOS/osu!"
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
