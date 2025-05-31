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
  version = "6.2.0-unstable-2025-02-26";

  src = fetchFromGitHub {
    owner = "h3poteto";
    repo = "whalebird-desktop";
    rev = "4f84b962eb338a6251d32f67994b71dc1b44d796";
    hash = "sha256-BBd9VGLtab6DuMODBnEAdZ/aNp1xV/5vkyprUCHR4z8=";
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
    outputHash = "sha256-IDOtmpiVcqy7u/pf1ZqDxY+0fo0sh7cPYG8HKyOnVMk=";
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
