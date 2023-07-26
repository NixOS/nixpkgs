{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, yarn
, fixup_yarn_lock
, nodejs
, makeWrapper
, copyDesktopItems
, desktopToDarwinBundle
, electron
, makeDesktopItem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "podman-desktop";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-desktop";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-gEjcI+bfETYZB/pHDXRcNxNVDsbwuqQL1E22fMkIJHI=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    sha256 = "sha256-x0hqNxi6r1i3vBe1tJQl+Oht2St9VIH3Eq27MZLkojA=";
  };

  patches = [
    # podman should be installed with nix; disable auto-installation
    ./patches/extension-no-download-podman.patch
    ./patches/fix-yarn-lock-deterministic.patch
  ];

  postPatch = ''
    for file in packages/main/src/tray-animate-icon.ts extensions/podman/src/util.ts packages/main/src/plugin/certificates.ts; do
      substituteInPlace "$file" \
        --replace 'process.resourcesPath'          "'$out/share/lib/podman-desktop/resources'" \
        --replace '(process as any).resourcesPath' "'$out/share/lib/podman-desktop/resources'"
    done
  '';

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    yarn
    fixup_yarn_lock
    nodejs
    makeWrapper
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.isDarwin [
    desktopToDarwinBundle
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME="$TMPDIR"
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline run build
    yarn --offline run electron-builder --dir \
      --config .electron-builder.config.cjs \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/podman-desktop"
    cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/podman-desktop"

    install -Dm644 buildResources/icon.svg "$out/share/icons/hicolor/scalable/apps/podman-desktop.svg"

    makeWrapper '${electron}/bin/electron' "$out/bin/podman-desktop" \
      --add-flags "$out/share/lib/podman-desktop/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0

    runHook postInstall
  '';

  # see: https://github.com/containers/podman-desktop/blob/main/.flatpak.desktop
  desktopItems = [
    (makeDesktopItem {
      name = "podman-desktop";
      exec = "podman-desktop %U";
      icon = "podman-desktop";
      desktopName = "Podman Desktop";
      genericName = "Desktop client for podman";
      comment = finalAttrs.meta.description;
      categories = [ "Utility" ];
      startupWMClass = "Podman Desktop";
    })
  ];

  meta = with lib; {
    description = "A graphical tool for developing on containers and Kubernetes";
    homepage = "https://podman-desktop.io";
    changelog = "https://github.com/containers/podman-desktop/releases/tag/v${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ panda2134 ];
    inherit (electron.meta) platforms;
  };
})
