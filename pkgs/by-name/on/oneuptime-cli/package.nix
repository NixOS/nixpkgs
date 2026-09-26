{
  lib,
  buildNpmPackage,
  esbuild,
  fetchFromGitHub,
  nix-update-script,
  nodejs_26,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "oneuptime-cli";
  version = "12.0.33";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-rbubW94htXyIV6vNxz8YWv4wkMX3a25Dg+IF2aitgMI=";
  };

  sourceRoot = "${finalAttrs.src.name}/CLI";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-ktF7nHccPrpyV20D+k0588guyFgSRxqCsX/IPQwNnk8=";

  nativeBuildInputs = [
    esbuild
    versionCheckHook
  ];

  # Common ships ESM with extensionless relative imports, which Node's ESM resolver rejects.
  postBuild = ''
    (
      cd node_modules/Common

      find build/dist -name '*.js' -exec esbuild \
        --format=cjs \
        --platform=node \
        --outbase=build/dist \
        --outdir=. \
        --log-level=error \
        {} +

      rm -rf build
    )
  '';

  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line interface for managing OneUptime resources";
    homepage = "https://github.com/OneUptime/oneuptime";
    changelog = "https://github.com/OneUptime/oneuptime/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "oneuptime";
    platforms = lib.platforms.all;
  };
})
