{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  makeWrapper,
  nodejs_26,
  npm-lockfile-fix,
}:

let
  # Common and the six frontends are separate npm projects that depend on each other by path, so each needs its own deps
  workspaces = {
    "packages/Common" = "sha256-V6nzTdEQ2fOjf5chylsqsYBWBZe3Km4On0oZUHmq7tU=";
    "packages/App/FeatureSet/Accounts" = "sha256-6bMrPixdsmbblG2PAsc1qIytqF/YL0wPdo01LoDQARU=";
    "packages/App/FeatureSet/AdminDashboard" = "sha256-a0Xv56CkY2+lifiisQ86YMxb4LgzDA7K7fCm6PvcgCQ=";
    "packages/App/FeatureSet/BrowserRecorder" = "sha256-WxJuw3APGP/nGdccss+TfXCy9QI0SO5/eb7hj2wRLJ0=";
    "packages/App/FeatureSet/Dashboard" = "sha256-j8cDJG+CBNgIxS+WLAFjylk6MDQmDS9lrqDazI0RjUM=";
    "packages/App/FeatureSet/PublicDashboard" = "sha256-VG8//qZc+hjZRM3cZVo9sCNAqSsGi1WHzul4bPTg4rI=";
    "packages/App/FeatureSet/StatusPage" = "sha256-stxooVxO7vd9pDzgwuV2HIcjxYDyRIKVwFCtWnKkl7g=";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "oneuptime-app";
  version = "14.0.28";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-WeW9HxGNyR+Zh6M6e2lPgwHqHAjovxDROVsvYyEiY+s=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/App";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-GHmjiANIHl87bWxMCtz4s3l28pIPhjY753SBh4OvYsA=";

  nativeBuildInputs = [ makeWrapper ];

  # unpackPhase only makes sourceRoot writable, and Common sits outside it.
  # ee/ is the Enterprise Edition (ee/LICENSE, not Apache-2.0); the frontend
  # build bundles it whenever it is on disk, so build like upstream's
  # community image: without it.
  postPatch = ''
    chmod -R u+w ../..
    rm -rf ../../ee
  '';

  preBuild = lib.concatLines (
    lib.mapAttrsToList (
      dir: hash:
      let
        deps = fetchNpmDeps {
          name = "oneuptime-${lib.toLower (baseNameOf dir)}-npm-deps-${finalAttrs.version}";
          src = "${finalAttrs.src}/${dir}";
          # Upstream ships some of these lockfiles without `resolved`/`integrity` on a chunk of their entries, which cannot be fetched
          nativeBuildInputs = [ npm-lockfile-fix ];
          preBuild = "npm-lockfile-fix package-lock.json";
          inherit hash;
        };
      in
      ''
        (
          cd ../../${dir}
          # npmConfigHook requires both lockfiles to be identical, so take the
          # repaired one back out of the fetched deps.
          cp ${deps}/package-lock.json package-lock.json
          export npmDeps=${deps}
          npmConfigHook
        )
      ''
    ) workspaces
  );

  npmBuildScript = "build-frontends:prod";

  # The Dashboard service worker bakes both into its cache key at build time,
  # falling back to md5(Date.now()), which would make $out unreproducible.
  env = {
    GIT_SHA = finalAttrs.version;
    APP_VERSION = finalAttrs.version;
    ONEUPTIME_EDITION = "community";
  };

  postBuild = ''
    # The same generator stamps a wall-clock timestamp nothing reads.
    sed -i 's/^ \* Generated at: .*/ * Generated at: (reproducible build)/' \
      FeatureSet/Dashboard/public/sw.js
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/lib/oneuptime
    cp -a ../Common $out/lib/oneuptime/Common
    cp -a . $out/lib/oneuptime/App

    # Some FeatureSets and Common resolve views, assets and docs against the Docker image's WORKDIR rather than their own location.
    find $out/lib/oneuptime -type f \( -name '*.ts' -o -name '*.ejs' \) \
      -not -path '*/node_modules/*' -not -path '*/Tests/*' \
      -exec sed -i \
        "s#/usr/src/app#$out/lib/oneuptime/App#g" {} +

    makeWrapper ${lib.getExe nodejs_26} $out/bin/oneuptime-app \
      --chdir $out/lib/oneuptime/App \
      --add-flags "--no-node-snapshot --require ts-node/register $out/lib/oneuptime/App/Index.ts" \
      --set TS_NODE_TRANSPILE_ONLY 1 \
      --set APP_VERSION ${finalAttrs.version}

    makeWrapper ${lib.getExe nodejs_26} $out/bin/oneuptime-app-migrate \
      --chdir $out/lib/oneuptime/App \
      --add-flags "--no-node-snapshot --require ts-node/register $out/lib/oneuptime/App/Migrate.ts" \
      --set TS_NODE_TRANSPILE_ONLY 1 \
      --set APP_VERSION ${finalAttrs.version}

    runHook postInstall
  '';

  meta = {
    description = "OneUptime server, dashboard, and status pages";
    homepage = "https://github.com/OneUptime/oneuptime";
    changelog = "https://github.com/OneUptime/oneuptime/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "oneuptime-app";
    platforms = lib.platforms.linux;
  };
})
