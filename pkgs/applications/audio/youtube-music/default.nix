{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  electron,
  python3,
  copyDesktopItems,
  nodejs,
  pnpm,
  makeDesktopItem,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "youtube-music";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "th-ch";
    repo = "youtube-music";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M8YFpeauM55fpNyHSGQm8iZieV0oWqOieVThhglKKPE=";
  };

  patches = [
    # MPRIS's DesktopEntry property needs to match the desktop entry basename
    ./fix-mpris-desktop-entry.patch
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-xZQ8rnLGD0ZxxUUPLHmNJ6mA+lnUHCTBvtJTiIPxaZU=";
  };

  nativeBuildInputs = [
    makeWrapper
    python3
    nodejs
    pnpm.configHook
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
      exec = "youtube-music %u";
      icon = "youtube-music";
      desktopName = "YouTube Music";
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
    ln -s "$out/Applications/YouTube Music.app/Contents/MacOS/YouTube Music" $out/bin/youtube-music
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p "$out/share/youtube-music"
    cp -r pack/*-unpacked/{locales,resources{,.pak}} "$out/share/youtube-music"

    pushd assets/generated/icons/png
    for file in *.png; do
      install -Dm0644 $file $out/share/icons/hicolor/''${file//.png}/apps/youtube-music.png
    done
    popd
  ''
  + ''

    runHook postInstall
  '';

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    makeWrapper ${electron}/bin/electron $out/bin/youtube-music \
      --add-flags $out/share/youtube-music/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Electron wrapper around YouTube Music";
    homepage = "https://th-ch.github.io/youtube-music/";
    changelog = "https://github.com/th-ch/youtube-music/blob/master/changelog.md#${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.src.tag
    }";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aacebedo
      SuperSandro2000
    ];
    mainProgram = "youtube-music";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
