{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "garnet";
  version = "1.0.80";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "garnet";
    tag = "v${version}";
    hash = "sha256-9B2Ai+W6+rZ8xLrrO7d8jd6LYWaMGIq3a+lz8rY32uA=";
  };

  projectFile = "main/GarnetServer/GarnetServer.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk =
    with dotnetCorePackages;
    sdk_9_0
    // {
      inherit
        (combinePackages [
          sdk_9_0
          sdk_8_0
        ])
        packages
        targetPackages
        ;
    };

  dotnetBuildFlags = [
    "-f"
    "net9.0"
  ];
  dotnetInstallFlags = dotnetBuildFlags;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Remote cache-store from Microsoft Research";
    longDescription = ''
      A remote cache-store that offers strong performance, scalability,
      storage, recovery, cluster sharding, key migration, replication features,
      and compatibility with existing Redis clients
    '';
    homepage = "https://microsoft.github.io/garnet/";
    changelog = "https://github.com/microsoft/garnet/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "GarnetServer";
  };
}
