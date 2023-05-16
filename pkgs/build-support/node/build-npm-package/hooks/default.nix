<<<<<<< HEAD
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
=======
{ lib, makeSetupHook, nodejs, srcOnly, buildPackages, makeWrapper }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

{
  npmConfigHook = makeSetupHook
    {
      name = "npm-config-hook";
      substitutions = {
        nodeSrc = srcOnly nodejs;
<<<<<<< HEAD
        nodeGyp = "${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js";

        # Specify `diff`, `jq`, and `prefetch-npm-deps` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong binaries.
        diff = "${diffutils}/bin/diff";
        jq = "${jq}/bin/jq";
        prefetchNpmDeps = "${prefetch-npm-deps}/bin/prefetch-npm-deps";
=======

        # Specify `diff`, `jq`, and `prefetch-npm-deps` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong binaries.
        diff = "${buildPackages.diffutils}/bin/diff";
        jq = "${buildPackages.jq}/bin/jq";
        prefetchNpmDeps = "${buildPackages.prefetch-npm-deps}/bin/prefetch-npm-deps";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
      propagatedBuildInputs = [
        installShellFiles
        makeWrapper
      ];
      substitutions = {
        hostNode = "${nodejs}/bin/node";
        jq = "${jq}/bin/jq";
=======
      propagatedBuildInputs = [ buildPackages.makeWrapper ];
      substitutions = {
        hostNode = "${nodejs}/bin/node";
        jq = "${buildPackages.jq}/bin/jq";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    } ./npm-install-hook.sh;
}
