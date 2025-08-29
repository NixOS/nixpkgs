{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "1.1.1";
  executables = "csharpier";

  nugetHash = "sha256-B0ijqWm3eZ31T+C5zRr4TkmfPsOfseaHpGPYZf5Yiw4=";

  meta = with lib; {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "csharpier";
  };
}
