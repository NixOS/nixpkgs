{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "1.0.2";
  executables = "csharpier";

  nugetHash = "sha256-FPcdTWhdIhl0MgOsWcCzgzLyHFyz0szLYQUBUFoe3Cs=";

  meta = with lib; {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "csharpier";
  };
}
