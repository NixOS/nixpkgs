{
  lib,
  srcOnly,
  makeSetupHook,
  nodejs,
  jq,
  prefetch-npm-deps,
  diffutils,
}:

{
  customConfigHook = makeSetupHook {
    name = "custom-npm-config-hook";
    substitutions = {
      nodeSrc = srcOnly nodejs;
      nodeGyp = "${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js";
      diff = "${diffutils}/bin/diff";
      jq = "${jq}/bin/jq";
      prefetchNpmDeps = "${prefetch-npm-deps}/bin/prefetch-npm-deps";
      nodeVersion = nodejs.version;
      nodeVersionMajor = lib.versions.major nodejs.version;
    };
  } ./npm-config-hook.sh;
}
