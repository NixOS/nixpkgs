{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nodejs,
  pnpm_9,
  rubyPackages_4_0,
  ruby_4_0,
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
      lib
      nodejs
      rubyPackages_4_0
      ruby_4_0
      stdenv
      yarnBuildHook
      yarnConfigHook
      yarnInstallHook
      ;
  };

  prettier-plugin-xml = import ./prettier/plugin-xml {
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
}
