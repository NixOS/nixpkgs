{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  nodejs,
  electron,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:
stdenv.mkDerivation (final: {
  pname = "splayer";
  version = "3.0.0-beta.2";

  src = fetchFromGitHub {
    owner = "imsyy";
    repo = "SPlayer";
    tag = "v${final.version}";
    fetchSubmodules = false;
    hash = "sha256-q4jMwIILuz9Uci/1m429Y5tHE2rkfxctu9QCA8jrJkk=";
  };

  pnpm = pnpm_10;

  pnpmDeps = final.pnpm.fetchDeps {
    inherit (final) pname version src;
    fetcherVersion = 2;
    hash = "sha256-lA08+i+SpMB95MAi/N5mxbcBed0FRchroT5e2nwnXuA=";
  };

  nativeBuildInputs = [
    final.pnpm.configHook
    nodejs
    makeWrapper
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postConfigure = ''
    cp .env.example .env
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build

    npm exec electron-builder -- \
        --dir \
        --config electron-builder.yml \
        -c.electronDist=${electron.dist} \
        -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/splayer"
    cp -Pr --no-preserve=ownership dist/*-unpacked/{locales,resources{,.pak}} $out/share/splayer

    _icon_sizes=(16x16 32x32 96x96 192x192 256x256 512x512)
    for _icons in "''${_icon_sizes[@]}";do
      install -D public/icons/favicon-$_icons.png $out/share/icons/hicolor/$_icons/apps/splayer.png
    done

    makeWrapper '${lib.getExe electron}' "$out/bin/splayer" \
      --add-flags $out/share/splayer/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "splayer";
      desktopName = "SPlayer";
      exec = "splayer %U";
      terminal = false;
      type = "Application";
      icon = "splayer";
      startupWMClass = "SPlayer";
      comment = "A minimalist music player";
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Simple Netease Cloud Music player";
    homepage = "https://github.com/imsyy/SPlayer";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    mainProgram = "splayer";
    platforms = lib.platforms.linux;
  };
})
