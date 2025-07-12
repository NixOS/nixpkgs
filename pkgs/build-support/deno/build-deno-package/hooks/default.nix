{
  makeSetupHook,
  lib,
}:
{
  denoTaskSuffix,
  denoTaskPrefix,
  binaryEntrypointPath,
  denortPackage,
}:
{
  denoConfigHook = makeSetupHook {
    name = "deno-config-hook";
    substitutions = {
      denortBinary = lib.optionalString (binaryEntrypointPath != null) (lib.getExe' denortPackage "denort");
    };
  } ./deno-config-hook.sh;

  denoBuildHook = makeSetupHook {
    name = "deno-build-hook";
    substitutions = {
      inherit denoTaskSuffix denoTaskPrefix;
    };
  } ./deno-build-hook.sh;

  denoInstallHook = makeSetupHook {
    name = "deno-install-hook";
  } ./deno-install-hook.sh;
}
