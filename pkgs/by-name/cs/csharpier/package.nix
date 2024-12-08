{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "0.30.2";
  executables = "dotnet-csharpier";

  nugetHash = "sha256-MrpsVlIYyrlu3VvEPcLQRgD2lhfu8ZTN3pUZrZ9nQcA=";

  meta = with lib; {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "dotnet-csharpier";
  };
}
