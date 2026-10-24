{
  cairo,
  curl,
  fetchFromGitHub,
  giflib,
  lib,
  libjpeg,
  librsvg,
  makeWrapper,
  node-gyp,
  nodejs_26,
  pango,
  pixman,
  pkg-config,
  python3,
  runCommand,
  stdenv,
  vips,
  yarn-berry_4,
}:

let
  # Upstream requires node >= 26 (engines field in package.json)
  nodejs = nodejs_26;
  yarn-berry = yarn-berry_4.override { inherit nodejs; };
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "maintainerr";
  version = "3.31.0";

  src = fetchFromGitHub {
    owner = "Maintainerr";
    repo = "Maintainerr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9kX4b95LqP9QtkTPHZkelAIRjRKX0/pWcsSzDNE9gAU=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-/xjVKHbk/f+/7NNIBhNpOcTJ5INxtNYMmNpoSFRmaEU=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry
    # Native modules must be built against the headers of the node that runs them
    (yarn-berry.yarnBerryConfigHook.override { inherit nodejs; })
    makeWrapper
    python3
    pkg-config
    node-gyp
  ];

  buildInputs = [
    cairo
    pango
    libjpeg
    giflib
    pixman
    librsvg
    vips
  ];

  env.SHARP_FORCE_GLOBAL_LIBVIPS = 1;

  disallowedReferences = [ python3 ];

  # Migrations are looked up at the Docker image's install path in production
  postPatch = ''
    substituteInPlace apps/server/src/app/config/typeOrmConfig.ts \
      --replace-fail "/opt/app/apps/server/dist/database/migrations" \
                     "$out/lib/maintainerr/apps/server/dist/database/migrations"
  '';

  buildPhase = ''
    runHook preBuild

    # Upstream's Dockerfile builds the UI with this placeholder base path and
    # rewrites it at container start; it is removed again in installPhase
    echo "VITE_BASE_PATH=/__PATH_PREFIX__" >> apps/ui/.env
    yarn turbo build
    yarn workspaces focus --all --production

    # Build better-sqlite3 and sharp from source instead of loading their
    # bundled prebuilt binaries. better-sqlite3 only compiles itself when no
    # prebuild matches the host, and sharp has no install script at all.
    rm -r node_modules/better-sqlite3/prebuilds node_modules/@img/sharp-*
    (cd node_modules/better-sqlite3 && node-gyp rebuild)
    (cd node_modules/sharp && node install/build.js)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/maintainerr/apps/server $out/lib/maintainerr/packages/contracts

    cp -r node_modules $out/lib/maintainerr/

    cp -r apps/server/dist apps/server/package.json $out/lib/maintainerr/apps/server/
    if [ -d apps/server/node_modules ]; then
      cp -r apps/server/node_modules $out/lib/maintainerr/apps/server/
    fi
    cp -r apps/ui/dist $out/lib/maintainerr/apps/server/dist/ui
    cp -r apps/server/assets $out/lib/maintainerr/apps/server/dist/assets

    cp -r packages/contracts/dist packages/contracts/package.json $out/lib/maintainerr/packages/contracts/
    if [ -d packages/contracts/node_modules ]; then
      cp -r packages/contracts/node_modules $out/lib/maintainerr/packages/contracts/
    fi

    # Serve the UI from the root path, as BASE_PATH cannot be applied to the read-only store
    find $out/lib/maintainerr/apps/server/dist/ui -type f \
      -exec sed -i 's,/__PATH_PREFIX__,,g' {} +

    # Remove native build artifacts that bloat the closure. node-gyp is kept
    # as a production dependency by yarn but only needed for building, and its
    # patched shebangs would pull python into the closure.
    rm -r $out/lib/maintainerr/node_modules/{node-gyp,.bin/node-gyp}
    find $out/lib/maintainerr/node_modules \( \
      -name config.gypi \
      -o -name .deps \
      -o -name obj.target \
      -o -name '*Makefile' \
      -o -name '*.target.mk' \
    \) -prune -exec rm -r {} +

    # The environment mirrors upstream's docker/start.sh and Dockerfile:
    # npm_package_version is how the app reports its own version, and io_uring
    # is disabled as a workaround for https://github.com/libuv/libuv/pull/4141
    makeWrapper ${lib.getExe nodejs} $out/bin/maintainerr \
      --chdir $out/lib/maintainerr/apps/server \
      --add-flags dist/main.js \
      --set NODE_ENV production \
      --set npm_package_version ${finalAttrs.version} \
      --set UV_USE_IO_URING 0

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    # alias for nix-update to be able to find and update this attribute
    inherit (finalAttrs) offlineCache;
    tests.simple =
      runCommand "maintainerr-test"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
            curl
          ];
        }
        ''
          export DATA_DIR=$TMPDIR/data
          mkdir -p $DATA_DIR
          maintainerr &
          curl --fail --silent --show-error --retry 60 --retry-delay 1 --retry-connrefused \
            http://127.0.0.1:6246/api/health/ready
          curl --fail --silent --show-error http://127.0.0.1:6246/ | grep -q '<div id="root">'
          kill %1
          touch $out
        '';
  };

  meta = {
    description = "Rules-based media library maintenance tool for Plex/Jellyfin";
    homepage = "https://github.com/Maintainerr/Maintainerr";
    changelog = "https://github.com/Maintainerr/Maintainerr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiriwalawren ];
    mainProgram = "maintainerr";
    platforms = lib.platforms.linux;
  };
})
