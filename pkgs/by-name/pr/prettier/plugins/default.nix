{
  fetchFromGitHub,
  fetchYarnDeps,
  gems,
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

  ## Prettier: failed to parse buffer
  prettier-plugin-ruby = import ./prettier/plugin-ruby {
    inherit
      fetchFromGitHub
      fetchYarnDeps
      gems
      nodejs
      stdenv
      yarnBuildHook
      yarnConfigHook
      yarnInstallHook
      ;
  };
}
