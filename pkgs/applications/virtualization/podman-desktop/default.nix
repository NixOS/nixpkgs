{ lib
, stdenv
, fetchFromGitHub
, applyPatches
, fetchYarnDeps
, yarn
, fixup-yarn-lock
, nodejs
, makeWrapper
, copyDesktopItems
, electron
, makeDesktopItem
, xcbuild
, autoSignDarwinBinariesHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "podman-desktop";
  version = "1.12.0";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "containers";
      repo = "podman-desktop";
      rev = "v${finalAttrs.version}";
      sha256 = "sha256-AdiomKM2RfJQKnyrcsdh8FtX7NuAj3g0KQ3pzy76gYI=";
    };
    # fix handling of Unix epoch timestamps for zip header, https://github.com/cthackers/adm-zip/pull/518
    # apply the patch early so that fetchYarnDeps can pull the patched yarn.lock
    patches = [
      ./patches/0001-chore-deps-bump-adm-zip-from-0.5.14-to-0.5.15.patch
    ];
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    sha256 = "sha256-y3ftK2SrysaWoHKEUeTF7aFp3yKmKcdVEJtOOKLr2G0=";
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
    fixup-yarn-lock
    nodejs
    makeWrapper
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    copyDesktopItems
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild.xcrun
    autoSignDarwinBinariesHook
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME="$TMPDIR"
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline run build

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Disable code signing during build on macOS.
    export CSC_IDENTITY_AUTO_DISCOVERY=false
    sed -i "/afterSign/d" .electron-builder.config.cjs
  '' + ''
    yarn --offline run electron-builder --dir \
      --config .electron-builder.config.cjs \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/podman-desktop"
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv dist/mac*/Podman\ Desktop.app $out/Applications
    ln -s $out/Applications/Podman\ Desktop.app/Contents/Resources "$out/share/lib/podman-desktop/resources"

    makeWrapper "$out/Applications/Podman Desktop.app/Contents/MacOS/Podman Desktop" $out/bin/podman-desktop
  '' + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/podman-desktop"

    install -Dm644 buildResources/icon.svg "$out/share/icons/hicolor/scalable/apps/podman-desktop.svg"

    makeWrapper '${electron}/bin/electron' "$out/bin/podman-desktop" \
      --add-flags "$out/share/lib/podman-desktop/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0
  '' + ''

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
    mainProgram = "podman-desktop";
  };
})
