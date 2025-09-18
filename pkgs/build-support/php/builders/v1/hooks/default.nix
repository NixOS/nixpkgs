{
  lib,
  makeSetupHook,
  jq,
  writeShellApplication,
  cacert,
  buildPackages,
}:

let
  php-script-utils = writeShellApplication {
    name = "php-script-utils";
    runtimeInputs = [ jq ];
    text = builtins.readFile ./php-script-utils.bash;
  };
in
{
  composerRepositoryHook = makeSetupHook {
    name = "composer-repository-hook.sh";
    propagatedNativeBuildInputs = [
      jq
    ];
    propagatedBuildInputs = [
      cacert
    ];
    substitutions = {
      phpScriptUtils = lib.getExe php-script-utils;
    };
  } ./composer-repository-hook.sh;

  composerInstallHook = makeSetupHook {
    name = "composer-install-hook.sh";
    propagatedNativeBuildInputs = [
      jq
    ];
    propagatedBuildInputs = [
      cacert
    ];
    substitutions = {
      # Specify the stdenv's `diff` by abspath to ensure that the user's build
      # inputs do not cause us to find the wrong `diff`.
      cmp = "${lib.getBin buildPackages.diffutils}/bin/cmp";
      phpScriptUtils = lib.getExe php-script-utils;
    };
  } ./composer-install-hook.sh;

  composerWithPluginVendorHook = makeSetupHook {
    name = "composer-with-plugin-vendor-hook.sh";
    propagatedNativeBuildInputs = [
      jq
    ];
    propagatedBuildInputs = [
      cacert
    ];
    substitutions = {
      # Specify the stdenv's `diff` by abspath to ensure that the user's build
      # inputs do not cause us to find the wrong `diff`.
      cmp = "${lib.getBin buildPackages.diffutils}/bin/cmp";
      phpScriptUtils = lib.getExe php-script-utils;
    };
  } ./composer-with-plugin-vendor-hook.sh;
}
