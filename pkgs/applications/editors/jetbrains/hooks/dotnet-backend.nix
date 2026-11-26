{
  # keep-sorted start
  bash,
  dotnetCorePackages,
  lib,
  makeSetupHook,
  # keep-sorted end
}:
makeSetupHook {
  name = "jetbrains-dotnet-backend-hook";
  substitutions = {
    shell = lib.getExe bash;
    # TODO: Match the .NET version shipped by each IDE; see https://github.com/NixOS/nixpkgs/issues/489048
    dotnet = "${dotnetCorePackages.sdk_10_0-source}/share/dotnet";
  };
  meta.teams = [ lib.teams.jetbrains ];
} ./dotnet-backend-hook.sh
