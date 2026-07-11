{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule {
  pname = "depotdownloader";
  version = "3.4.0-unstable-2026-05-14";

  src = fetchFromGitHub {
    owner = "Iluhadesu";
    repo = "DepotDownloader";
    rev = "0ab6676c51f27d3b9e63278e3c18484d4d2bf063";
    hash = "sha256-qC9EakT1tu8NNwbmj7HmYgcIoEUlMRRHNGnKggVNDgk=";
  };

  projectFile = "DepotDownloader.sln";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  meta = {
    description = "Fork of DepotDownloader to be used by BSManager";
    license = lib.licenses.gpl2Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "DepotDownloader";
  };
}
