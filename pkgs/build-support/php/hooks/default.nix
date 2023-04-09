{ buildPackages
, callPackage
, php
, jq
, lib
, makeSetupHook
, stdenvNoCC
, unzip
, xz
, git
}:

{
  composerSetupHook = makeSetupHook {
      name = "composer-setup-hook.sh";
      propagatedBuildInputs = [ php unzip xz git jq ];
      substitutions = {
      };
    } ./composer-setup-hook.sh;

  composerInstallHook = makeSetupHook {
      name = "composer-install-hook.sh";
      propagatedBuildInputs = [ php unzip xz git jq ];
      substitutions = { };
    } ./composer-install-hook.sh;
}
