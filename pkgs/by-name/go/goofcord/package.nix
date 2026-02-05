{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  bun,
  nodejs_24,
  nix-update-script,
  electron,
  pipewire,
  libpulseaudio,
  libxkbcommon,
  libX11,
  libxcb,
  libXtst,
  makeShellWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "goofcord";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Milkshiift";
    repo = "GoofCord";
    rev = "v${finalAttrs.version}";
    hash = "sha256-c/NDju5K4DnKLZjE0ZD0TSpm5YWhZUXGmZs/AJhF7Jk=";
  };

  nativeBuildInputs = [
    bun
    nodejs_24
    makeShellWrapper
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
    pipewire
    libxkbcommon
    libX11
    libxcb
    libXtst
    (lib.getLib stdenv.cc.cc)
  ];

  node-modules = callPackage ./node-modules.nix { };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node-modules} node_modules
    patchShebangs node_modules/.bin
    patchShebangs node_modules/@typescript/native-preview/bin

    runHook postConfigure
  '';

  preBuild = lib.optionalString stdenv.hostPlatform.isLinux ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
  '';

  buildPhase = ''
    runHook preBuild

    bun run build

    node node_modules/electron-builder/out/cli/cli.js \
      --dir \
      -c.electronDist="${if stdenv.hostPlatform.isLinux then "electron-dist" else electron.dist}" \
      -c.electronVersion="${electron.version}" \
      -c.npmRebuild=false

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/goofcord"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/goofcord"

    install -Dm644 "assets/gf_icon.png" "$out/share/icons/hicolor/256x256/apps/goofcord.png"

    # use makeShellWrapper (instead of the makeBinaryWrapper provided by wrapGAppsHook3) for proper shell variable expansion
    # see https://github.com/NixOS/nixpkgs/issues/172583
    makeShellWrapper "${lib.getExe electron}" "$out/bin/goofcord" \
      --add-flags "$out/share/lib/goofcord/resources/app.asar" \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxkbcommon
          libX11
          libxcb
          libXtst
        ]
      }" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "goofcord";
      genericName = "Internet Messenger";
      desktopName = "GoofCord";
      exec = "goofcord %U";
      icon = "goofcord";
      comment = finalAttrs.meta.description;
      keywords = [
        "discord"
        "vencord"
        "electron"
        "chat"
      ];
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      startupWMClass = "GoofCord";
      terminal = false;
    })
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Highly configurable and privacy-focused Discord client";
    homepage = "https://github.com/Milkshiift/GoofCord";
    downloadPage = "https://github.com/Milkshiift/GoofCord";
    license = lib.licenses.osl3;
    maintainers = with lib.maintainers; [ nyabinary ];
    platforms = lib.platforms.linux;
    mainProgram = "goofcord";
  };
})
