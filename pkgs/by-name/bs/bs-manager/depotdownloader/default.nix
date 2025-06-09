{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule {
  pname = "depotdownloader";
  version = "2.7.4-unstable-2024-12-01";

  src = fetchFromGitHub {
    owner = "Iluhadesu";
    repo = "DepotDownloader";
    rev = "a9f58e5513b72bd00b623a83e1460b3c5db49248";
    hash = "sha256-+QfwKQJzyXqUvTn8kKP7lYHvbtRtdJ7jc/W7E87tV7w=";
  };

  projectFile = "DepotDownloader.sln";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

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
