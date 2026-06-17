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
} ./dotnet-hook.sh
