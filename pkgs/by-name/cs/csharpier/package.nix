{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "0.30.5";
  executables = "dotnet-csharpier";

  nugetHash = "sha256-8NuhwRhvEZtmPtgbLLNbTOLUoDAihtkKE8aw5UQ0O5A=";

  meta = {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zoriya ];
    mainProgram = "dotnet-csharpier";
  };
}
