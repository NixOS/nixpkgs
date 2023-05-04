{ buildPackages
, callPackage
, dieHook
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
  composerSetupHook =
    makeSetupHook
      {
        name = "composer-setup-hook.sh";
        propagatedBuildInputs = [
          dieHook
        ];
      }
      ./composer-setup-hook.sh;

  fetchComposerDeps = callPackage ./fetch-deps.nix { };
}
