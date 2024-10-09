{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "0.29.1";
  executables = "dotnet-csharpier";

  nugetHash = "sha256-VW9QzbQfbY3Tz+Gz3hQ7VC4wOtwfIYV1Yq2WJz6bL04=";

  meta = with lib; {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "dotnet-csharpier";
  };
}
