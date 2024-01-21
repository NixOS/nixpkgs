{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "0.27.0";
  executables = "dotnet-csharpier";

  nugetSha256 = "sha256-aI8sZoUXAA/bOn7ITMkBFXHeTVRm9O/qX+bWfOKwRDs=";

  meta = with lib; {
    description = "An opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "dotnet-csharpier";
  };
}
