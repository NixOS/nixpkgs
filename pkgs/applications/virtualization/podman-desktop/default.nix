{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, copyDesktopItems
, electron
, nodejs
, pnpm
, makeDesktopItem
, autoSignDarwinBinariesHook
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "podman-desktop";
  version = "1.13.2";

  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-desktop";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-07lf9jy22JUT+Vc5y9Tu1nkWaXU5RTdu3GibcvQsSs8=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-LPsNRd1c/cQeyBn3LZKnKeAsZ981sOkLYTnXIZL82LA=";
  };

  patches = [
    # podman should be installed with nix; disable auto-installation
    ./patches/extension-no-download-podman.patch
  ];

  postPatch = ''
    for file in packages/main/src/tray-animate-icon.ts packages/main/src/plugin/certificates.ts; do
      substituteInPlace "$file" \
        --replace-fail 'process.resourcesPath' "'$out/share/lib/podman-desktop/resources'"
    done
    substituteInPlace "extensions/podman/packages/extension/src/util.ts" \
      --replace-fail '(process as any).resourcesPath' "'$out/share/lib/podman-desktop/resources'"
  '';

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    makeWrapper nodejs pnpm.configHook
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    copyDesktopItems
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    autoSignDarwinBinariesHook
  ];

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pnpm build
    ./node_modules/.bin/electron-builder \
      --dir \
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
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
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

  meta = {
    description = "A graphical tool for developing on containers and Kubernetes";
    homepage = "https://podman-desktop.io";
    changelog = "https://github.com/containers/podman-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ booxter panda2134 ];
    inherit (electron.meta) platforms;
    mainProgram = "podman-desktop";
  };
})
