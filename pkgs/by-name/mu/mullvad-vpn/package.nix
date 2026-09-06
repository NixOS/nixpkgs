{
  lib,
  buildNpmPackage,
  mullvad,
  nodejs_22,
  replaceVars,
  electron,
  copyDesktopItems,
  grpc-tools,
  librsvg,
  makeBinaryWrapper,
  versionCheckHook,
  makeDesktopItem,
}:

buildNpmPackage (finalAttrs: {
  pname = "mullvad-vpn";
  inherit (mullvad) src version;

  nodejs = nodejs_22;
  npmDepsHash = "sha256-9IfPNfo3MJ7Ipvvlqm76iTh1d1RYFJfVZiKlh5ia8TM=";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  patches = [
    (replaceVars ./0001-distribution-configuration.patch {
      inherit (finalAttrs) version;
      electron-dist = electron.dist;
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    grpc-tools
    librsvg
    makeBinaryWrapper
  ];

  buildInputs = [
    electron
  ];

  env.ELECTRON_OVERRIDE_DIST_PATH = electron.dist;

  # We cannot use 'sourceRoot' as the build script needs access
  # to 'desktop/../dist'.
  postPatch = ''
    cd desktop/
  '';

  # The npmConfigHook only patches executables from the main
  # 'node_modules/' directory, but Mullvad uses a workspace.
  postConfigure = ''
    patchShebangs --build packages/mullvad-vpn/node_modules
  '';

  # Dependencies used by the main workspace.
  preBuild = ''
    npm -w windows-utils run build-typescript
    npm -w nseventforwarder run build-typescript
  '';

  npmWorkspace = "mullvad-vpn";
  npmBuildScript = "pack:linux";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mullvad-vpn/
    cp -r ../dist/*-unpacked/{locales,resources{,.pak}} $out/share/mullvad-vpn/
    cp ../graphics/icon{-square,}.svg $out/share/mullvad-vpn/resources/

    install -D ../graphics/icon.svg $out/share/icons/hicolor/scalable/apps/mullvad-vpn.svg
    for size in 16 32 48 64 128 256 512 1024; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      rsvg-convert -o $out/share/icons/hicolor/''${size}x''${size}/apps/mullvad-vpn.png -w $size -h $size ../graphics/icon.svg
    done

    makeWrapper ${lib.getExe electron} $out/bin/mullvad-vpn \
        --add-flags $out/share/mullvad-vpn/resources/app.asar \
        --set MULLVAD_DISABLE_UPDATE_NOTIFICATION 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --inherit-argv0

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    npm test

    runHook postCheck
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  desktopItems = lib.singleton (makeDesktopItem {
    name = "mullvad-vpn";
    categories = [ "Network" ];
    comment = "Mullvad VPN client";
    desktopName = "Mullvad VPN";
    exec = "mullvad-vpn";
    icon = "mullvad-vpn";
    startupWMClass = "Mullvad VPN";
    terminal = false;
  });

  passthru.hasMullvadGUI = true;

  meta = {
    homepage = "https://mullvad.net/";
    description = "Graphical user interface for Mullvad VPN";
    longDescription = "**NOTE:** This package does not contain the Mullvad VPN Daemon. The actual VPN service is available on `pkgs.mullvad`, and it must be used in conjunction with this package.";
    changelog = "https://github.com/mullvad/mullvadvpn-app/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    inherit (electron.meta) platforms;
    maintainers = with lib.maintainers; [
      airone01
      jackr
      sigmasquadron
    ];
    mainProgram = "mullvad-vpn";
  };
})
