{ lib, makeSetupHook, nodejs, srcOnly, diffutils, jq, makeWrapper }:

{
  npmConfigHook = makeSetupHook
    {
      name = "npm-config-hook";
      substitutions = {
        nodeSrc = srcOnly nodejs;

        # Specify the stdenv's `diff` and `jq` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong binaries.
        # The `.nativeDrv` stanza works like nativeBuildInputs and ensures cross-compiling has the right version available.
        diff = "${diffutils.nativeDrv or diffutils}/bin/diff";
        jq = "${jq.nativeDrv or jq}/bin/jq";

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
      deps = [ makeWrapper ];
      substitutions = {
        hostNode = "${nodejs}/bin/node";
        jq = "${jq.nativeDrv or jq}/bin/jq";
      };
    } ./npm-install-hook.sh;
}
