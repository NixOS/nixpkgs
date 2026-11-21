{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  actool,
  electron_45,
  python3,
  copyDesktopItems,
  nodejs,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeDesktopItem,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pear-desktop";
  version = "3.12.1";

  src = fetchFromGitHub {
    owner = "pear-devs";
    repo = "pear-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xea/MC/UgmCZfljRKe7MTER6uHdXYEAD7FNUT0OEoHU=";
  };

  patches = [
    # MPRIS's DesktopEntry property needs to match the desktop entry basename
    ./fix-mpris-desktop-entry.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-UbwYXliu7RFJhlo3tHbxFv4Co6MsM44Ha6ynkd0U4Lw=";
  };

  nativeBuildInputs = [
    makeWrapper
    python3
    nodejs
    pnpmConfigHook
    pnpm_12
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ actool ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ copyDesktopItems ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  postBuild = ''
    pnpm build

    cp -r ${electron_45.dist} electron-dist
    chmod -R u+w electron-dist

    ./node_modules/.bin/electron-builder \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron_45.version}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.github.th-ch.youtube-music";
      exec = "pear-desktop %u";
      icon = "pear-desktop";
      desktopName = "Pear Desktop";
      startupWMClass = "com.github.th-ch.youtube-music";
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
    cp -r pack/*-unpacked/resources "$out/share/pear-desktop"

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
    makeWrapper ${electron_45}/bin/electron $out/bin/pear-desktop \
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
      "aarch64-darwin"
    ];
  };
})
