{ stdenv
, lib
, fetchYarnDeps
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, fixup_yarn_lock
, yarn
, desktopToDarwinBundle
, fetchFromGitHub
, electron
, nodejs
, python3
, icoutils
}:

stdenv.mkDerivation rec {
  pname = "anilibrix";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "pavloniym";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qi48sdkLDZQZo1FDvdWc7iBBM7v6tANRrNZMDTdRlwM=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-P7t+Q1SVoLV1Xdl0ecMpodLo/3/dNO0+zn2Mrs0l/3c=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    fixup_yarn_lock
    makeWrapper
    nodejs
    nodejs.pkgs.node-gyp
    python3
    yarn
    icoutils
  ] ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  configurePhase = ''
    runHook preConfigure

    cp .env.example .env
    # wwnd.space is official api mirror without cloudflare
    echo API_ENDPOINT_URL=https://wwnd.space/ >> .env
    echo STATIC_ENDPOINT_URL=https://static.wwnd.space/ >> .env
    echo NODE_ENV=production >> .env

    export HOME="$TMPDIR"
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export NODE_ENV=production

    pushd node_modules/fibers/
    node build
    popd

    yarn --offline run build

    yarn --offline run electron-builder --dir \
      -c.electronDist=${electron}/lib/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/anilibrix"
    cp -r release/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/anilibrix"

    icotool -x ${src}/build/icons/app/anilibria.ico

    for s in 256 128 64 48 32 16; do
      install -Dm644 anilibria_*_"$s"x"$s"x32.png "$out"/share/icons/hicolor/"$s"x"$s"/apps/anilibrix.png
    done

    install -Dm644 ${src}/build/icons/app/anilibria.svg "$out/share/icons/hicolor/scalable/apps/anilibrix.svg"

    makeWrapper '${electron}/bin/electron' "$out/bin/anilibrix" \
      --add-flags "$out/share/lib/anilibrix/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems =
    [
      (makeDesktopItem {
        name = pname;
        exec = "${pname} %U";
        desktopName = "AniLibriX";
        comment = meta.description;
        genericName = "AniLibria desktop client";
        icon = pname;
        categories = [ "AudioVideo" "Player" "Video" ];
        keywords = [ "anime" "anilibria" ];
      })
    ];

  meta = with lib; {
    description = "Anilibria desktop movie app";
    homepage = "https://anilibria.app/app/anilibrix";
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
    license = licenses.mit;
    inherit (electron.meta) platforms;
  };
}
