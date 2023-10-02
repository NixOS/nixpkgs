{ makeSetupHook
, jq
, moreutils
, makeBinaryWrapper
, php
, cacert
}:

{
  composerRepositoryHook = makeSetupHook
    {
      name = "composer-repository-hook.sh";
      propagatedBuildInputs = [ jq moreutils php cacert ];
      substitutions = { };
    } ./composer-repository-hook.sh;

  composerInstallHook = makeSetupHook
    {
      name = "composer-install-hook.sh";
      propagatedBuildInputs = [ jq makeBinaryWrapper moreutils php cacert ];
      substitutions = { };
    } ./composer-install-hook.sh;
}
