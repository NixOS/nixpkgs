{
  lib,
  buildNpmPackage,
  cargo,
  darwin,
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
  rustPlatform,
  rustc,
  stdenv,
}:

buildNpmPackage (finalAttrs: {
  pname = "mullvad-vpn";
  inherit (mullvad) src version;

  nodejs = nodejs_22;
  npmDepsHash = "sha256-DWLMf+fHCm3hqKt25vmoZ+uEL90/hEpQS+5k8sBFo/c=";
  cargoDeps = mullvad.cargoDeps;
  cargoRoot = "..";

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
    grpc-tools
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
    librsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cargo
    darwin.sigtool
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [
    electron
  ];

  env.ELECTRON_OVERRIDE_DIST_PATH = electron.dist;

  # We cannot use 'sourceRoot' as the build script needs access
  # to 'desktop/../dist'.
  postPatch = ''
    cd desktop/
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Electron Builder modifies Electron's Info.plist while packaging, so copy it out of the
    # read-only Nix store into a writable build directory.
    cp -r ${electron.dist} ../electron-dist
    chmod -R u+w ../electron-dist
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
  npmBuildScript = if stdenv.hostPlatform.isDarwin then "pack:mac" else "pack:linux";

  installPhase =
    if stdenv.hostPlatform.isLinux then
      ''
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
      ''
    else
      ''
        runHook preInstall

        mkdir -p "$out/Applications" "$out/bin"
        cp -r "$NIX_BUILD_TOP"/source/dist/mac*/Mullvad\ VPN.app "$out/Applications/"

        # must be binary wrapper for signing to work
        wrapBinaryProgram "$out/Applications/Mullvad VPN.app/Contents/MacOS/Mullvad VPN" \
          --prefix PATH : ${lib.makeBinPath [ mullvad ]}

        makeWrapper "$out/Applications/Mullvad VPN.app/Contents/MacOS/Mullvad VPN" "$out/bin/mullvad-vpn" \
          --set MULLVAD_DISABLE_UPDATE_NOTIFICATION 1

        # Electron Builder's macOS signing is disabled because it invokes unsupported flags.
        # Instead, we sign the application executable with nixpkgs' sigtool.
        codesign --sign - --force \
          "$out/Applications/Mullvad VPN.app/Contents/MacOS/Mullvad VPN"

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

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "mullvad-vpn";
      categories = [ "Network" ];
      comment = "Mullvad VPN client";
      desktopName = "Mullvad VPN";
      exec = "mullvad-vpn";
      icon = "mullvad-vpn";
      startupWMClass = "Mullvad VPN";
      terminal = false;
    })
  ];

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
