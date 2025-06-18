{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchYarnDeps,
  makeDesktopItem,

  copyDesktopItems,
  dart-sass,
  makeWrapper,
  nodejs_20,
  pkg-config,
  yarnConfigHook,

  electron,
  libsecret,
  sqlite,
}:

let
  nodejs = nodejs_20;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "redisinsight";
  version = "2.68.0";

  src = fetchFromGitHub {
    owner = "RedisInsight";
    repo = "RedisInsight";
    rev = finalAttrs.version;
    hash = "sha256-rXp3C/Ui3vMBscsxlwU9fRF1bmvMrvXLtmJfGzfh1Rk=";
  };

  patches = [
    # the `file:` specifier doesn't seem to be supported with fetchYarnDeps
    # upstream uses it to point the cpu-features dependency to a stub package
    # so it's safe to remove
    ./remove-cpu-features.patch
  ];

  baseOfflineCache = fetchYarnDeps {
    name = "redisinsight-${finalAttrs.version}-base-offline-cache";
    inherit (finalAttrs) src patches;
    hash = "sha256-ORVftwl/8Yrug2MeqWfZTsHNTRJlpKGn2P7JCHUf3do=";
  };

  innerOfflineCache = fetchYarnDeps {
    name = "redisinsight-${finalAttrs.version}-inner-offline-cache";
    inherit (finalAttrs) src patches;
    postPatch = "cd redisinsight";
    hash = "sha256-yFfkpWV/GD2CcAzb0D3lNZwmqzEN6Bi1MjPyRwClaQ0=";
  };

  apiOfflineCache = fetchYarnDeps {
    name = "redisinsight-${finalAttrs.version}-api-offline-cache";
    inherit (finalAttrs) src patches;
    postPatch = "cd redisinsight/api";
    hash = "sha256-go7IR1UsW8TrWjaFSlC6/biUvb9cHo3PgJa16tF0XHo=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    nodejs
    (nodejs.python.withPackages (ps: [ ps.setuptools ]))
    pkg-config
    yarnConfigHook
  ];

  buildInputs = [
    sqlite # for `sqlite3` node module
    libsecret # for `keytar` node module
  ];

  postPatch = ''
    substituteInPlace redisinsight/api/config/default.ts \
      --replace-fail "process['resourcesPath']" "\"$out/share/redisinsight\""

    # has irrelevant files
    rm -r resources/app
  '';

  # will run yarnConfigHook manually later
  dontYarnInstallDeps = true;

  configurePhase = ''
    runHook preConfigure

    yarnOfflineCache="$baseOfflineCache" yarnConfigHook
    cd redisinsight
    yarnOfflineCache="$innerOfflineCache" yarnConfigHook
    cd api
    yarnOfflineCache="$apiOfflineCache" yarnConfigHook
    cd ../..

    export npm_config_nodedir=${electron.headers}
    export npm_config_sqlite=${lib.getDev sqlite}
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1
    npm rebuild --verbose --no-progress
    cd redisinsight
    npm rebuild --verbose --no-progress
    cd api
    npm rebuild --verbose --no-progress
    cd ../..

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # force the sass npm dependency to use our own sass binary instead of the bundled one
    substituteInPlace node_modules/sass/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'

    yarn --offline build:prod

    # TODO: Generate defaults. Currently broken because it requires network access.
    # yarn --offline --cwd=redisinsight/api build:defaults

    yarn --offline electron-builder \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false # we've already rebuilt the native libs using the electron headers

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/redisinsight"/{app,defaults,static/plugins,static/resources/plugins}

    cp -r release/*-unpacked/{locales,resources{,.pak}} "$out/share/redisinsight/app"
    mv "$out/share/redisinsight/app/resources/resources" "$out/share/redisinsight"

    # icons
    for icon in "$out/share/redisinsight/resources/icons"/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/redisinsight.png"
    done

    makeWrapper '${electron}/bin/electron' "$out/bin/redisinsight" \
      --add-flags "$out/share/redisinsight/app/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "redisinsight";
      exec = "redisinsight %u";
      icon = "redisinsight";
      desktopName = "RedisInsight";
      genericName = "RedisInsight Redis Client";
      comment = finalAttrs.meta.description;
      categories = [ "Development" ];
      startupWMClass = "redisinsight";
    })
  ];

  meta = {
    description = "Developer GUI for Redis";
    homepage = "https://github.com/RedisInsight/RedisInsight";
    license = lib.licenses.sspl;
    maintainers = with lib.maintainers; [
      tomasajt
    ];
    platforms = lib.platforms.linux;
  };
})
