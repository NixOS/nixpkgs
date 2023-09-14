{ makeSetupHook
, php
, jq
, moreutils
}:

{
  composerRepositoryHook = makeSetupHook
    {
      name = "composer-repository-hook.sh";
      propagatedBuildInputs = [ php jq moreutils ];
      substitutions = { };
    } ./composer-repository-hook.sh;

  composerInstallHook = makeSetupHook
    {
      name = "composer-install-hook.sh";
      propagatedBuildInputs = [ php jq moreutils ];
      substitutions = { };
    } ./composer-install-hook.sh;
}
