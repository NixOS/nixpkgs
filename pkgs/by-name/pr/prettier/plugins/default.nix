{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nodejs,
  pnpm,
  rubyPackages,
  ruby,
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
      pnpm
      ;
  };

  ## Prettier: failed to parse buffer
  prettier-plugin-ruby = import ./prettier/plugin-ruby {
    inherit
      fetchFromGitHub
      fetchYarnDeps
      lib
      nodejs
      stdenv
      yarnBuildHook
      yarnConfigHook
      yarnInstallHook
      rubyPackages
      ruby
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
