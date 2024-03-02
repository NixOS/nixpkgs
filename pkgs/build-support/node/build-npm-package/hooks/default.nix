{ lib
, srcOnly
, makeSetupHook
, makeWrapper
, nodejs
, jq
, prefetch-npm-deps
, diffutils
, installShellFiles
}:

{
  npmConfigHook = makeSetupHook
    {
      name = "npm-config-hook";
      substitutions = {
        nodeSrc = srcOnly nodejs;
        nodeGyp = "${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js";

        # Specify `diff`, `jq`, and `prefetch-npm-deps` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong binaries.
        diff = "${diffutils}/bin/diff";
        jq = "${jq}/bin/jq";
        prefetchNpmDeps = "${prefetch-npm-deps}/bin/prefetch-npm-deps";

        nodeVersion = nodejs.version;
        nodeVersionMajor = lib.versions.major nodejs.version;
      };
    } ./npm-config-hook.sh;

  npmBuildHook = makeSetupHook
    {
      name = "npm-build-hook";
    } ./npm-build-hook.sh;

  npmInstallHook = makeSetupHook
    {
      name = "npm-install-hook";
      propagatedBuildInputs = [
        installShellFiles
        makeWrapper
      ];
      substitutions = {
        hostNode = "${nodejs}/bin/node";
        jq = "${jq}/bin/jq";
      };
    } ./npm-install-hook.sh;
}
