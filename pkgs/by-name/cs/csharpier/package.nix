{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "1.2.5";
  executables = "csharpier";

  nugetHash = "sha256-VevPiNTtfRJvmK/eYlJtJEJkYkiSvRoP7nTq7q9Bs9I=";

  meta = {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zoriya ];
    mainProgram = "csharpier";
  };
}
