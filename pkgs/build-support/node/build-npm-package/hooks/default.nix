{ lib, makeSetupHook, nodejs, srcOnly, buildPackages, makeWrapper }:

{
  npmConfigHook = makeSetupHook
    {
      name = "npm-config-hook";
      substitutions = {
        nodeSrc = srcOnly nodejs;
        nodeGyp = "${buildPackages.nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js";

        # Specify `diff`, `jq`, and `prefetch-npm-deps` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong binaries.
        diff = "${buildPackages.diffutils}/bin/diff";
        jq = "${buildPackages.jq}/bin/jq";
        prefetchNpmDeps = "${buildPackages.prefetch-npm-deps}/bin/prefetch-npm-deps";

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
      propagatedBuildInputs = with buildPackages; [
        installShellFiles
        makeWrapper
      ];
      substitutions = {
        hostNode = "${nodejs}/bin/node";
        jq = "${buildPackages.jq}/bin/jq";
      };
    } ./npm-install-hook.sh;
}
