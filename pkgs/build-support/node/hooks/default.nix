{ lib, makeSetupHook, nodejs, srcOnly, buildPackages, makeWrapper }:

{
  npmConfigHook = makeSetupHook
    {
      name = "npm-config-hook";
      substitutions = {
        nodeSrc = srcOnly nodejs;

        # Specify `diff`, `jq`, and `prefetch-npm-deps` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong binaries.
        diff = "${buildPackages.diffutils}/bin/diff";
        jq = "${buildPackages.jq}/bin/jq";
        prefetchNpmDeps = "${buildPackages.prefetch-npm-deps}/bin/prefetch-npm-deps";

        nodeVersion = nodejs.version;
        nodeVersionMajor = lib.versions.major nodejs.version;
      };
    } ./npm-config-hook.sh;

  yarnConfigHook = makeSetupHook
    {
      name = "yarn-config-hook";
      substitutions = {
        nodeSrc = srcOnly nodejs;

        # Specify `diff`, `jq`, `yarn`, and `fixup_yarn_lock` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong binaries.
        diff = "${buildPackages.diffutils}/bin/diff";
        jq = "${buildPackages.jq}/bin/jq";
        yarn = "${buildPackages.yarn}/bin/yarn";
        fixupYarnLock = "${buildPackages.fixup_yarn_lock}/bin/fixup_yarn_lock";

        nodeVersion = nodejs.version;
        nodeVersionMajor = lib.versions.major nodejs.version;
      };
    } ./yarn-config-hook.sh;

  npmBuildHook = makeSetupHook
    {
      name = "npm-build-hook";
    } ./npm-build-hook.sh;

  npmInstallHook = makeSetupHook
    {
      name = "npm-install-hook";
      deps = [ buildPackages.makeWrapper ];
      substitutions = {
        hostNode = "${nodejs}/bin/node";
        jq = "${buildPackages.jq}/bin/jq";
      };
    } ./npm-install-hook.sh;
}
