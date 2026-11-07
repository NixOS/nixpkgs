{
  lib,
  buildNpmPackage,
  nodejs,
  version,
  src,
}:

buildNpmPackage {
  pname = "seahub-frontend";
  inherit version src nodejs;

  __structuredAttrs = true;
  strictDeps = true;

  sourceRoot = "${src.name}/frontend";

  npmDepsHash = "sha256-B6hm2x9Z+YiN7+GCbKBQYyAgeZG5DuuVphTk6DAyfzA=";

  # sass-loader is present without a pinned sass compiler, so peer-dependency
  # resolution is not clean
  npmFlags = [ "--legacy-peer-deps" ];

  npmBuildScript = "build";

  env.NODE_OPTIONS = "--max-old-space-size=4096 --openssl-legacy-provider";

  installPhase = ''
    runHook preInstall

    # SPA and Bundle manifest
    mkdir -p $out
    cp -r build/frontend $out/frontend
    cp webpack-stats.pro.json $out/webpack-stats.pro.json

    runHook postInstall
  '';

  meta = {
    description = "Prebuilt web frontend assets for Seahub";
    homepage = "https://github.com/haiwen/seahub";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.all;
  };
}
