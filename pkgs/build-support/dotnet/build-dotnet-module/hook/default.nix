{
  lib,
  which,
  coreutils,
  makeSetupHook,
  # Passed from ../default.nix
  dotnet-runtime,
}:
makeSetupHook {
  name = "dotnet-hook";
  substitutions = {
    dotnetRuntime = dotnet-runtime;
    wrapperPath = lib.makeBinPath [
      which
      coreutils
    ];
  };
  meta.license = lib.licenses.mit;
} ./dotnet-hook.sh
