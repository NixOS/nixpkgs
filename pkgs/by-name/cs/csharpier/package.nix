{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "0.27.2";
  executables = "dotnet-csharpier";

  nugetSha256 = "sha256-P4v4h09FuisIry9B/6batrG0CpLqnrkxnlk1yEd1JbY=";

  meta = with lib; {
    description = "An opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "dotnet-csharpier";
  };
}
