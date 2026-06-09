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
  composerVendorHook = makeSetupHook {
    name = "composer-vendor-hook.sh";
    propagatedNativeBuildInputs = [
      jq
    ];
    propagatedBuildInputs = [
      cacert
    ];
    substitutions = {
      phpScriptUtils = lib.getExe php-script-utils;
    };
    meta.license = lib.licenses.mit;
  } ./composer-vendor-hook.sh;

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
    meta.license = lib.licenses.mit;
  } ./composer-install-hook.sh;
}
