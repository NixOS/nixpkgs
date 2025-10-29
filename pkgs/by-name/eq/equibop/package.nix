{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron,
  libicns,
  pipewire,
  libpulseaudio,
  autoPatchelfHook,
  bun,
  nodejs,
  withTTS ? true,
  withMiddleClickScroll ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "equibop";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equibop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ASU2a4CtlvglHWzv0AASuEWeycfBfSpi+ZuHsu6K0ko=";
  };

  postPatch = ''
    substituteInPlace scripts/build/build.mts \
      --replace-fail 'const gitHash = execSync("git rev-parse HEAD", { encoding: "utf-8" }).trim();' 'const gitHash = "${lib.fakeHash}"'

    # disable auto updates
    substituteInPlace src/main/updater.ts \
      --replace-fail 'const isOutdated = autoUpdater.checkForUpdates().then(res => Boolean(res?.isUpdateAvailable));' 'const isOutdated = false;'
  '';

  node-modules = callPackage ./node-modules.nix { };

  nativeBuildInputs = [
    bun
    nodejs
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

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node-modules} node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run build

    bun run compileArrpc

    # can't run it via bunx / npx since fixupPhase was skipped for node_modules
    node node_modules/electron-builder/out/cli/cli.js \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false

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
    # fails to update node-modules FOD :/
    # updateScript = nix-update-script {
    #   extraArgs = [
    #     "--subpackage"
    #     "node-modules"
    #   ];
    # };
  };

  meta = {
    description = "Custom Discord App aiming to give you better performance and improve linux support";
    homepage = "https://github.com/Equicord/Equibop";
    changelog = "https://github.com/Equicord/Equibop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      NotAShelf
      rexies
    ];
    mainProgram = "equibop";
    # I am not confident in my ability to support Darwin, please PR if this is important to you
    platforms = lib.platforms.linux;
  };
})
