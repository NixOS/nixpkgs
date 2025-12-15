{
  lib,
  copyDesktopItems,
  electron_37,
  fetchFromGitHub,
  fetchpatch,
  deltachat-rpc-server,
  makeDesktopItem,
  makeWrapper,
  nodejs,
  pkg-config,
  pnpm_9,
  python3,
  rustPlatform,
  stdenv,
  testers,
  deltachat-desktop,
  yq,
}:

let
  deltachat-rpc-server' = deltachat-rpc-server.overrideAttrs rec {
    version = "2.33.0";
    src = fetchFromGitHub {
      owner = "chatmail";
      repo = "core";
      tag = "v${version}";
      hash = "sha256-4cnYTtm5bQ86BgMOOH5d881ahjuFFOxVuGffRp3Nbw4=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      pname = "chatmail-core";
      inherit version src;
      hash = "sha256-TOGSvvFKsWshfMqGNEOtjhHcpTJ0FAiK6RigmlT4AFA=";
    };
  };
  electron = electron_37;
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "deltachat-desktop";
  version = "2.33.0";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PA2Faq1AmFxxizN1+NDYRB3uFI2bXdGshtyfHwY2btM=";
  };

  patches = [
    # https://github.com/deltachat/deltachat-desktop/pull/5854
    (fetchpatch {
      name = "dont-load-env-file-in-production.patch";
      url = "https://github.com/deltachat/deltachat-desktop/commit/e0eca1672b2f0c951b96c1e921219d2a4a4dbcb0.patch";
      hash = "sha256-/Dc8VjdF10qJOrEa0dJeBib+R+8kb5yD4/iKt9/VnBA=";
    })
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-4BAcCzPZbCjUfHTnJ98TzcfI5UnfMmGdbdvCFaQNNsk=";
  };

  nativeBuildInputs = [
    yq
    makeWrapper
    nodejs
    pkg-config
    pnpm.configHook
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    SKIP_FUSES = true; # EACCES: permission denied
    VERSION_INFO_GIT_REF = finalAttrs.src.tag;
  };

  buildPhase = ''
    runHook preBuild

    test \
      $(yq -r '.catalogs.default."@deltachat/jsonrpc-client".version' pnpm-lock.yaml) \
      = ${deltachat-rpc-server'.version} \
      || (echo "error: deltachat-rpc-server version does not match jsonrpc-client" && exit 1)

    test \
      $(yq -r '.importers."packages/target-electron".devDependencies.electron.version' pnpm-lock.yaml | grep -E -o "^[0-9]+") \
      = ${lib.versions.major electron.version} \
      || (echo 'error: electron version doesn not match package-lock.json' && exit 1)

    pnpm --filter=@deltachat-desktop/target-electron build4production

    pnpm --filter=@deltachat-desktop/target-electron pack:generate_config
    pnpm --filter=@deltachat-desktop/target-electron pack:patch-node-modules
    pnpm --filter=@deltachat-desktop/target-electron exec electron-builder \
      --config ./electron-builder.json5 \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    pushd packages/target-electron/dist/*-unpacked/resources/app.asar.unpacked
    rm node_modules/@deltachat/stdio-rpc-server-*/deltachat-rpc-server
    ln -s ${lib.getExe deltachat-rpc-server'} node_modules/@deltachat/stdio-rpc-server-*
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/DeltaChat
    cp -r packages/target-electron/dist/*-unpacked/{locales,resources{,.pak}} $out/opt/DeltaChat

    makeWrapper ${lib.getExe electron} $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags $out/opt/DeltaChat/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    install -Dt "$out/share/icons/hicolor/scalable/apps" images/tray/deltachat.svg

    runHook postInstall
  '';

  desktopItems = lib.singleton (makeDesktopItem {
    name = "deltachat";
    exec = "deltachat %u";
    icon = "deltachat";
    desktopName = "Delta Chat";
    genericName = "Delta Chat";
    comment = finalAttrs.meta.description;
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
    startupWMClass = "DeltaChat";
    mimeTypes = [
      "x-scheme-handler/openpgp4fpr"
      "x-scheme-handler/dcaccount"
      "x-scheme-handler/dclogin"
      "x-scheme-handler/mailto"
    ];
  });

  passthru.tests = {
    version = testers.testVersion {
      package = deltachat-desktop;
    };
  };

  meta = {
    description = "Email-based instant messaging for Desktop";
    homepage = "https://github.com/deltachat/deltachat-desktop";
    changelog = "https://github.com/deltachat/deltachat-desktop/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    mainProgram = "deltachat";
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
})
