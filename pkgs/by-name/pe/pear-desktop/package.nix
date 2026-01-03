{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  electron,
  python3,
  copyDesktopItems,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeDesktopItem,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pear-desktop";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "pear-devs";
    repo = "pear-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M8YFpeauM55fpNyHSGQm8iZieV0oWqOieVThhglKKPE=";
  };

  patches = [
    # MPRIS's DesktopEntry property needs to match the desktop entry basename
    ./fix-mpris-desktop-entry.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 2;
    hash = "sha256-xZQ8rnLGD0ZxxUUPLHmNJ6mA+lnUHCTBvtJTiIPxaZU=";
  };

  nativeBuildInputs = [
    makeWrapper
    python3
    nodejs
    pnpmConfigHook
    pnpm_10
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ copyDesktopItems ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  postBuild =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp -R ${electron.dist}/Electron.app Electron.app
      chmod -R u+w Electron.app
    ''
    + ''
      pnpm build
      ./node_modules/.bin/electron-builder \
        --dir \
        -c.electronDist=${if stdenv.hostPlatform.isDarwin then "." else electron.dist} \
        -c.electronVersion=${electron.version}
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.github.th_ch.youtube_music";
      exec = "pear-desktop %u";
      icon = "pear-desktop";
      desktopName = "Pear Desktop";
      startupWMClass = "com.github.th_ch.youtube_music";
      categories = [ "AudioVideo" ];
    })
  ];

  installPhase = ''
    runHook preInstall

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv pack/mac*/YouTube\ Music.app $out/Applications
    ln -s "$out/Applications/YouTube Music.app/Contents/MacOS/YouTube Music" $out/bin/pear-desktop
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p "$out/share/pear-desktop"
    cp -r pack/*-unpacked/{locales,resources{,.pak}} "$out/share/pear-desktop"

    pushd assets/generated/icons/png
    for file in *.png; do
      install -Dm0644 $file $out/share/icons/hicolor/''${file//.png}/apps/pear-desktop.png
    done
    popd
  ''
  + ''

    runHook postInstall
  '';

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    makeWrapper ${electron}/bin/electron $out/bin/pear-desktop \
      --add-flags $out/share/pear-desktop/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Electron wrapper around YouTube Music";
    homepage = "https://github.com/pear-devs/pear-desktop";
    changelog = "https://github.com/pear-devs/pear-desktop/blob/master/changelog.md#${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.src.tag
    }";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aacebedo
      SuperSandro2000
    ];
    mainProgram = "pear-desktop";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
