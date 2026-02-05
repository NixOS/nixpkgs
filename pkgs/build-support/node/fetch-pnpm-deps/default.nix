{
  stdenvNoCC,
  callPackage,
  makeSetupHook,
  zstd,
}:
{
  fetchPnpmDeps = callPackage ./pnpm-fetch-deps.nix { };

  pnpmConfigHook = makeSetupHook {
    name = "pnpm-config-hook";
    propagatedBuildInputs = [
      zstd
    ];
    substitutions = {
      npmArch = stdenvNoCC.targetPlatform.node.arch;
      npmPlatform = stdenvNoCC.targetPlatform.node.platform;
    };
  } ./pnpm-config-hook.sh;
}
