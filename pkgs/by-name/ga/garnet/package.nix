{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "garnet";
<<<<<<< HEAD
  version = "1.0.89";
=======
  version = "1.0.86";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "garnet";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-DL87KIkC1lzqVJPAUqFp7d/MKFoWWS0Lo1/02dwkCxQ=";
=======
    hash = "sha256-EmwDc6kbOL++g1Xq4LoV3JuxYWSifOmv8vvWKsU3CE4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
