{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "0.30.3";
  executables = "dotnet-csharpier";

  nugetHash = "sha256-W+O6zrHkRru/s0MT0SGa58PlPHgFE4wxtqZj2GJDRos=";

  meta = with lib; {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "dotnet-csharpier";
  };
}
