{ buildPackages
, callPackage
, php
, jq
, lib
, makeSetupHook
, stdenvNoCC
, unzip
, _7zz
, xz
, git
, curl
, openssh
, cacert
, moreutils
}:

{
  composerRepositoryHook = makeSetupHook {
      name = "composer-repository-hook.sh";
      # TODO: How can we get rid of this list of tools
      # and inherit them from build-composer-project.buildInputs ?
      # Is it even a good idea?
      propagatedBuildInputs = [ php jq moreutils unzip _7zz xz git curl openssh cacert ];
      substitutions = {
      };
    } ./composer-repository-hook.sh;

  composerInstallHook = makeSetupHook {
      name = "composer-install-hook.sh";
      propagatedBuildInputs = [ php jq moreutils unzip _7zz xz git curl openssh cacert ];
      substitutions = { };
    } ./composer-install-hook.sh;
}
