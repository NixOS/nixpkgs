{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "enemizer";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "Ijwu";
    repo = "Enemizer";
    rev = "refs/tags/${version}";
    hash = "sha256-r9QD0vfs5xxR1yWvqDcnPceVrxqR9lN2PxVddWk125w=";
  };

  patches = [
    ./fix-build.patch
  ];

  projectFile = "EnemizerCLI.Core/EnemizerCLI.Core.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  executables = [ "EnemizerCLI.Core" ];

  meta = {
    changelog = "https://github.com/Ijwu/Enemizer/releases/tag/${version}";
    description = "A Link to the Past Enemy Randomizer";
    homepage = "https://github.com/Ijwu/Enemizer";
    license = lib.licenses.wtfpl;
    mainProgram = "EnemizerCLI.Core";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
