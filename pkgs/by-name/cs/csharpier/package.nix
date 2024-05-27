{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "0.28.2";
  executables = "dotnet-csharpier";

  nugetSha256 = "sha256-fXyE25niM80pPXCLC80Hm9XEHGUMx0XZOMxdVoA0h18=";

  meta = with lib; {
    description = "An opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "dotnet-csharpier";
  };
}
