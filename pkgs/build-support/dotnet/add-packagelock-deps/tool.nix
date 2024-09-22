{
  buildDotnetModule,
  dotnetCorePackages,
  lib,
}:

buildDotnetModule {
  pname = "dependencyTool";
  version = "1.0.0";

  src = ./dependencyTool;

  projectFile = "dependencyTool.csproj";

  nugetLockFile = "packages.lock.json";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  useDotnetFromEnv = true;

  meta = {
    description = "Tool for helping pull .NET package lock dependencies";
    homepage = "https://github.com/nixos/nixpkgs/";
    changelog = "https://github.com/nixos/nixpkgs/releases";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "dependencyTool";
  };
}
