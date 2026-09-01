{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
}:
buildDotnetGlobalTool rec {
  pname = "dotnet-outdated";
  nugetName = "dotnet-outdated-tool";
  version = "4.8.1";

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  nugetHash = "sha256-f5su1er+1wP35rrU3S+qvwfPp/C55tR7xZ4bv4z7zL0=";

  meta = {
    description = ".NET Core global tool to display and update outdated NuGet packages in a project";
    downloadPage = "https://www.nuget.org/packages/dotnet-outdated-tool";
    homepage = "https://github.com/dotnet-outdated/dotnet-outdated";
    changelog = "https://github.com/dotnet-outdated/dotnet-outdated/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilioziniades ];
    mainProgram = "dotnet-outdated";
  };
}
