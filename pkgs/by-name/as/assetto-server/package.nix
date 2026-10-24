{
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  lib,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "AssettoServer";
  version = "0.0.54";

  src = fetchFromGitHub {
    owner = "compujuckel";
    repo = "AssettoServer";
    rev = "v${version}";
    sha256 = "sha256-ax8xBpIEcBCSg9dSI7osC2cZFq+PrIzDUm7UpDVvAPI=";
  };
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  selfContainedBuild = true;

  projectFile = "AssettoServer/AssettoServer.csproj";
  nugetDeps = ./deps.nix;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://assettoserver.org/";
    description = "Custom Assetto Corsa server with focus on freeroam";
    changelog = "https://github.com/compujuckel/AssettoServer/releases/tag/v${version}";
    mainProgram = "AssettoServer";
    platforms = with lib.platforms; [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ amackillop ];
  };
}
