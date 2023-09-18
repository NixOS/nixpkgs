{ makeSetupHook
, jq
, moreutils
, makeBinaryWrapper
, php
}:

{
  composerRepositoryHook = makeSetupHook
    {
      name = "composer-repository-hook.sh";
      propagatedBuildInputs = [ jq moreutils php ];
      substitutions = { };
    } ./composer-repository-hook.sh;

  composerInstallHook = makeSetupHook
    {
      name = "composer-install-hook.sh";
      propagatedBuildInputs = [ jq makeBinaryWrapper moreutils php ];
      substitutions = { };
    } ./composer-install-hook.sh;
}
