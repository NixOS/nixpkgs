{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  xcodebuild,
  electron,
  mosh-catty,
  eternal-terminal,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

let
  resourcesDir =
    if stdenvNoCC.hostPlatform.isDarwin then
      "$out/Applications/Netcatty.app/Contents/Resources"
    else
      "$out/share/netcatty/resources";
in

buildNpmPackage (finalAttrs: {
  pname = "netcatty";
  version = "1.1.80";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "binaricat";
    repo = "Netcatty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c/ixZbnBFcb5Zih7YCm/cKrUrmW+3oa+WP6Rkgtugwc=";
  };

  npmDepsHash = "sha256-zeCs6hAS4/kRw0zPx6v+VxksphXFG6NKTxUkah8NA4g=";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [ xcodebuild ]; # better-sqlite3

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    npm_config_target = electron.version;
    npm_config_nodedir = electron.headers;
  };

  # workaround for https://github.com/electron/electron/issues/31121
  postPatch = ''
    substituteInPlace electron-builder.config.cjs \
      --replace-fail "beforePack: './scripts/beforePackCursorSdk.cjs'," "" \
      --replace-fail "afterPack: './scripts/afterPackMacUuid.cjs'," ""

    substituteInPlace \
      electron/{cli/{externalMcpDiscoveryPath,discoveryPath},bridges/terminalBridge}.cjs \
      --replace-fail "process.resourcesPath" "'${resourcesDir}'"
  '';

  buildPhase = ''
    runHook preBuild

    npm run build

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    npm exec electron-builder -- \
      --dir \
      --config electron-builder.config.cjs \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenvNoCC.hostPlatform.isDarwin then
        ''
          mkdir -p $out/{Applications,bin}
          cp -r release/mac*/Netcatty.app $out/Applications
          makeWrapper $out/Applications/Netcatty.app/Contents/MacOS/Netcatty $out/bin/netcatty
        ''
      else
        ''
          mkdir -p $out/share/netcatty
          cp -r release/*-unpacked/{locales,resources{,.pak}} $out/share/netcatty/

          for size in 16 32 48 64 128 256 512; do
            install -D build/icons/"$size"x"$size".png \
              $out/share/icons/hicolor/"$size"x"$size"/apps/netcatty.png
          done

          makeWrapper ${lib.getExe electron} $out/bin/netcatty \
            --add-flags $out/share/netcatty/resources/app.asar \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
            --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
            --set-default ELECTRON_IS_DEV 0 \
            --inherit-argv0
        ''
    }

    mkdir -p ${resourcesDir}/{et,mosh}
    ln -s ${lib.getExe eternal-terminal} ${resourcesDir}/et/et
    ln -s ${lib.getExe mosh-catty} ${resourcesDir}/mosh/mosh-client

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "netcatty";
      desktopName = "Netcatty";
      exec = "netcatty %U";
      terminal = false;
      type = "Application";
      icon = "netcatty";
      startupWMClass = "Netcatty";
      comment = finalAttrs.meta.description;
      categories = [ "Development" ];
      mimeTypes = [
        "x-scheme-handler/ssh"
        "x-scheme-handler/telnet"
        "x-scheme-handler/jms"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Modern SSH manager and terminal app with host grouping, SFTP, keychain, port forwarding, and a rich UI";
    homepage = "https://netcatty.app/";
    downloadPage = "https://github.com/binaricat/Netcatty/releases";
    changelog = "https://github.com/binaricat/Netcatty/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "netcatty";
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
