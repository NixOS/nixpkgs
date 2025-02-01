{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
  nodejs_22,
  nix-update-script,
  electron,
  pipewire,
  libpulseaudio,
  makeShellWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  pnpm' = pnpm.override { nodejs = nodejs_22; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "goofcord";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Milkshiift";
    repo = "GoofCord";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hG8nHAuEHw/tjFnGKhSXwO+2l91OOnQUIAK05SvEquU=";
  };

  nativeBuildInputs = [
    pnpm'.configHook
    nodejs_22
    makeShellWrapper
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    libpulseaudio
    pipewire
    stdenv.cc.cc.lib
  ];

  pnpmDeps = pnpm'.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-wF7G8rs1Fg7whEftQ554s4C2CixP5/1oFudR5yY07Rk=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    npm exec electron-builder -- \
      --dir \
      -c.electronDist="${electron.dist}" \
      -c.electronVersion="${electron.version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/goofcord"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/goofcord"

    install -Dm644 "build/icon.png" "$out/share/icons/hicolor/256x256/apps/goofcord.png"

    # use makeShellWrapper (instead of the makeBinaryWrapper provided by wrapGAppsHook3) for proper shell variable expansion
    # see https://github.com/NixOS/nixpkgs/issues/172583
    makeShellWrapper "${lib.getExe electron}" "$out/bin/goofcord" \
      --add-flags "$out/share/lib/goofcord/resources/app.asar" \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer}}" \
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
    maintainers = with lib.maintainers; [ nyanbinary ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "goofcord";
  };
})
