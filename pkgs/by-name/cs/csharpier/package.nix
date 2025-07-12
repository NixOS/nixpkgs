{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "1.0.3";
  executables = "csharpier";

  nugetHash = "sha256-DJe3zpzFCBjmsNmLMgIC1clLxo/exPZ+xHUmdpKMaMo=";

  meta = with lib; {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "csharpier";
  };
}
