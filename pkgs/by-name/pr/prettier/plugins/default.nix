{
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  pnpm_9,
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
  ...
}:
{
  prettier-plugin-php = import ./prettier/plugin-php {
    inherit
      fetchFromGitHub
      fetchYarnDeps
      nodejs
      stdenv
      yarnBuildHook
      yarnConfigHook
      yarnInstallHook
      ;
  };

  prettier-plugin-pug = import ./prettier/plugin-pug {
    inherit
      fetchFromGitHub
      nodejs
      stdenv
      pnpm_9
      ;
  };
}
