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
    "Common" = "sha256-ilohCaFFNPbJ/wBxpUx7HkCFulPjZAPwWfIa9RHMyAU=";
    "App/FeatureSet/Accounts" = "sha256-d6OU3XLmi6R5mHMThfrGsq4st46bFzhEv+9zudWbuQg=";
    "App/FeatureSet/AdminDashboard" = "sha256-7Xo3HQUDM9/0V8bUIWmi5nwBRWwleLqlW1d21s/CeJE=";
    "App/FeatureSet/BrowserRecorder" = "sha256-H+1Byqx8m0ZAHiFDu+6pS5IdaNSfSCEz1vU4ZWzsV10=";
    "App/FeatureSet/Dashboard" = "sha256-LOkjrCcMxAWVzKXuemsgJ/Q9/ike+MmEuV6TarYZpMI=";
    "App/FeatureSet/PublicDashboard" = "sha256-Bqpj3YOyAZNgMwoPU/GlJYKUZOAn7IU8/fg+qZ30Q3A=";
    "App/FeatureSet/StatusPage" = "sha256-4qOJBGktwY1b6kY14tMLGdw3kYICSy9Z/xrwEpyzoms=";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "oneuptime-app";
  version = "12.0.33";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-rbubW94htXyIV6vNxz8YWv4wkMX3a25Dg+IF2aitgMI=";
  };

  sourceRoot = "${finalAttrs.src.name}/App";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-C3hyoVMFAPX7SNliuxizO2TJI2Nid9LsvdRW7SjIWk4=";

  nativeBuildInputs = [ makeWrapper ];

  # unpackPhase only makes sourceRoot writable, and Common sits outside it.
  postPatch = ''
    chmod -R u+w ..
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
          cd ../${dir}
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
        "s#/usr/src/app#$out/lib/oneuptime/App#g; s#/usr/src/Common#$out/lib/oneuptime/Common#g" {} +

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
