{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "1.1.2";
  executables = "csharpier";

  nugetHash = "sha256-dlWIqlErXT0l8WaLwtgKb7xpYVunkZihaJ3EzKqaqFE=";

  meta = {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zoriya ];
    mainProgram = "csharpier";
  };
}
