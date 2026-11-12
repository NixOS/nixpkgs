{
  src,
  version,
  routerBasePath,

  buildNpmPackage,
  nodejs,
}:
buildNpmPackage {
  pname = "audiobookshelf-client";
  inherit src version nodejs;

  sourceRoot = "${src.name}/client";

  npmDepsHash = "sha256-mQSppjp21z+xqLZekI/0qJ1gtLhX3L2CyC6e/l9COL4=";

  env.ROUTER_BASE_PATH = routerBasePath;

  npmRebuildFlags = [ "--ignore-scripts" ];

  npmBuildScript = "generate";

  installPhase = ''
    runHook preInstall
    cp -r dist "$out"
    runHook postInstall
  '';
}
