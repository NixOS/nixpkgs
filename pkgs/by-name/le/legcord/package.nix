{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
  nodejs,
  electron,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  pipewire,
  libpulseaudio,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "legcord";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "Legcord";
    repo = "Legcord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6egqI1JhnRc8YwzAvyy4Xg9Z9dEfG7wIbMfUgQ+4IBA=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    nodejs
    # we use a script wrapper here for environment variable expansion at runtime
    # https://github.com/NixOS/nixpkgs/issues/172583
    makeWrapper
    copyDesktopItems
    # legcord uses venmic, which is a shipped as a prebuilt node module
    # and needs to be patched
    autoPatchelfHook
  ];

  buildInputs = [
    libpulseaudio
    pipewire
    (lib.getLib stdenv.cc.cc)
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-nobOORfhwlGEvNt+MfDKd3rXor6tJHDulz5oD1BGY4I=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    # Replicating the build step to copy venmic from the vendored node module manually,
    # since the install script does not do this for whatever reason
    cp ./node_modules/@vencord/venmic/prebuilds/venmic-addon-linux-x64/node-napi-v7.node ./dist/venmic-x64.node
    cp ./node_modules/@vencord/venmic/prebuilds/venmic-addon-linux-arm64/node-napi-v7.node ./dist/venmic-arm64.node

    # Patch venmic before putting it into the ASAR archive
    autoPatchelf ./dist

    pnpm exec electron-builder \
      --dir \
      -c.asarUnpack="**/*.node" \
      -c.electronDist="${electron.dist}" \
      -c.electronVersion="${electron.version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/legcord"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/legcord"

    install -Dm644 "build/icon.png" "$out/share/icons/hicolor/256x256/apps/legcord.png"

    # use makeShellWrapper (instead of the makeBinaryWrapper provided by wrapGAppsHook3) for proper shell variable expansion
    # see https://github.com/NixOS/nixpkgs/issues/172583
    makeShellWrapper "${lib.getExe electron}" "$out/bin/legcord" \
      --add-flags "$out/share/lib/legcord/resources/app.asar" \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  desktopItems = [
    (makeDesktopItem {
      name = "legcord";
      genericName = "Internet Messenger";
      desktopName = "Legcord";
      exec = "legcord %U";
      icon = "legcord";
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
      startupWMClass = "Legcord";
      terminal = false;
    })
  ];

  passthru = {
    inherit (finalAttrs) pnpmDeps;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lightweight, alternative desktop client for Discord";
    homepage = "https://legcord.app";
    downloadPage = "https://github.com/Legcord/Legcord";
    license = lib.licenses.osl3;
    maintainers = with lib.maintainers; [
      wrmilling
      water-sucks
      nyabinary
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "legcord";
  };
})
