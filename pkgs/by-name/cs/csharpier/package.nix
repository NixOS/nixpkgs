{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "1.0.3";
  executables = "csharpier";

  nugetHash = "sha256-DJe3zpzFCBjmsNmLMgIC1clLxo/exPZ+xHUmdpKMaMo=";

  meta = {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zoriya ];
    mainProgram = "csharpier";
  };
}
