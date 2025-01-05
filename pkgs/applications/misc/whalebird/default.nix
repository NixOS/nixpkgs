{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
  cacert,
  gitMinimal,
  yarn,
}:
stdenv.mkDerivation rec {
  pname = "whalebird";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "h3poteto";
    repo = "whalebird-desktop";
    rev = "v${version}";
    hash = "sha256-Jf+vhsfVjNrxdBkwwh3D3d2AlsGHfmEn90dq2QrKi2k=";
  };
  # we cannot use fetchYarnDeps because that doesn't support yarn 2/berry lockfiles
  offlineCache = stdenv.mkDerivation {
    name = "whalebird-${version}-offline-cache";
    inherit src;

    nativeBuildInputs = [
      cacert # needed for git
      gitMinimal # needed to download git dependencies
      yarn
    ];

    buildPhase = ''
      export HOME=$(mktemp -d)
      yarn config set enableTelemetry 0
      yarn config set cacheFolder $out
      yarn config set --json supportedArchitectures.os '[ "linux" ]'
      yarn config set --json supportedArchitectures.cpu '[ "arm64", "x64" ]'
      yarn
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-SJCJq1vkO/jH9YgB3rV/pK4wV5Prm3sNjOj9YwL6XTw=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    yarn
  ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Whalebird";
      comment = meta.description;
      categories = [ "Network" ];
      exec = "whalebird";
      icon = "whalebird";
      name = "whalebird";
    })
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    yarn config set enableTelemetry 0
    yarn config set cacheFolder ${offlineCache}

    yarn --immutable-cache
    yarn run nextron build --no-pack
    yarn run electron-builder --dir \
      --config electron-builder.yml \
      -c.electronDist="${electron.dist}" \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r ./dist/*-unpacked $out/opt/Whalebird

    # Install icons
    # Taken from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=whalebird#n41
    for i in 16 32 128 256 512; do
      install -Dm644 "resources/icons/icon.iconset/icon_$i"x"$i.png" \
        "$out/share/icons/hicolor/$i"x"$i/apps/whalebird.png"
    done
    install -Dm644 "resources/icons/icon.iconset/icon_32x32@2x.png" \
      "$out/share/icons/hicolor/64x64/apps/whalebird.png"

    makeWrapper "${electron}/bin/electron" "$out/bin/whalebird" \
      --add-flags "$out/opt/Whalebird/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Single-column Fediverse client for desktop";
    mainProgram = "whalebird";
    homepage = "https://whalebird.social";
    changelog = "https://github.com/h3poteto/whalebird-desktop/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ weathercold ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
