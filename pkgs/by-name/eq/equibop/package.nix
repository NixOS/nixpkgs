{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  equicord,
  electron,
  libicns,
  pipewire,
  libpulseaudio,
  autoPatchelfHook,
  pnpm_9,
  nodejs,
  nix-update-script,
  withTTS ? true,
  withMiddleClickScroll ? false,
  # Enables the use of Equicord from nixpkgs instead of
  # letting Equibop manage it's own version
  withSystemEquicord ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "equibop";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equibop";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-LGgmWaC7iYj0Mx5wPKmLkYV2ozyhkiwrE4v4uFB0erg=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash = "sha256-dIz/HyhzFU86QqQEQ9qWSthKB9HfoRJbmpc3raWNbcA=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    # XXX: Equibop *does not* ship venmic as a prebuilt node module. The package
    # seems to build with or without this hook, but I (NotAShelf) don't have the
    # time to test the consequences of removing this hook. Please open a pull
    # request if this bothers you in some way.
    autoPatchelfHook
    copyDesktopItems
    # we use a script wrapper here for environment variable expansion at runtime
    # https://github.com/NixOS/nixpkgs/issues/172583
    makeWrapper
  ];

  buildInputs = [
    libpulseaudio
    pipewire
    (lib.getLib stdenv.cc.cc)
  ];

  patches =
    [ ./disable_update_checking.patch ]
    ++ lib.optional withSystemEquicord (
      replaceVars ./use_system_equicord.patch {
        inherit equicord;
      }
    );

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  buildPhase = ''
    runHook preBuild

    pnpm build
    pnpm exec electron-builder \
      --dir \
      -c.asarUnpack="**/*.node" \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  postBuild = ''
    pushd build
    ${libicns}/bin/icns2png -x icon.icns
    popd
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt/Equibop
    cp -r dist/*unpacked/resources $out/opt/Equibop/

    for file in build/icon_*x32.png; do
      file_suffix=''${file//build\/icon_}
      install -Dm0644 $file $out/share/icons/hicolor/''${file_suffix//x32.png}/apps/equibop.png
    done

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/equibop \
      --add-flags $out/opt/Equibop/resources/app.asar \
      ${lib.optionalString withTTS "--add-flags \"--enable-speech-dispatcher\""} \
      ${lib.optionalString withMiddleClickScroll "--add-flags \"--enable-blink-features=MiddleClickAutoscroll\""} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  desktopItems = makeDesktopItem {
    name = "equibop";
    desktopName = "Equibop";
    exec = "equibop %U";
    icon = "equibop";
    startupWMClass = "Equibop";
    genericName = "Internet Messenger";
    keywords = [
      "discord"
      "equibop"
      "electron"
      "chat"
    ];
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
  };

  passthru = {
    inherit (finalAttrs) pnpmDeps;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Custom Discord App aiming to give you better performance and improve linux support";
    homepage = "https://github.com/Equicord/Equibop";
    changelog = "https://github.com/Equicord/Equibop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [
      lib.maintainers.NotAShelf
    ];
    mainProgram = "equibop";
    # I am not confident in my ability to support Darwin, please PR if this is important to you
    platforms = lib.platforms.linux;
  };
})
