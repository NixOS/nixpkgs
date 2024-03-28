{
  mkYarnPackage,
  nodejs,
  fetchFromGitLab,
  fetchYarnDeps,
  lib,
  ...
}:
{

  telegram-bridge = import ./plugin-telegram-bridge {
    inherit
      mkYarnPackage
      nodejs
      fetchFromGitLab
      fetchYarnDeps
      lib
      ;
  };
}
