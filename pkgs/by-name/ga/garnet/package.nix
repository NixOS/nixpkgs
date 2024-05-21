{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  garnet,
  dotnetCorePackages,
}:
buildDotnetModule {
  pname = "garnet";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "garnet";
    rev = "v${garnet.version}";
    hash = "sha256-GBXRRLP4bBvKHr7tqvrOFFkTpUiiSYxj3DBrrehIl84=";
  };

  projectFile = "main/GarnetServer/GarnetServer.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = with dotnetCorePackages; combinePackages [ sdk_6_0 sdk_7_0 sdk_8_0 ];
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  dotnetInstallFlags = ["-f" "net8.0"];

  meta = with lib; {
    mainProgram = "GarnetServer";
    description = "A remote cache-store from Microsoft Research";
    longDescription = ''
      A remote cache-store that offers strong performance, scalability,
      storage, recovery, cluster sharding, key migration, replication features,
      and compatibility with existing Redis clients
    '';
    homepage = "https://microsoft.github.io/garnet/";
    changelog = "https://github.com/microsoft/garnet/releases/tag/v${garnet.version}";
    license = licenses.mit;
    maintainers = with maintainers; [getchoo];
  };
}
