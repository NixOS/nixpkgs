{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "1.2.0";
  executables = "csharpier";

  nugetHash = "sha256-YEIUoh6af8DIAN6hh+3H5XbTbdJwe+f7TPXdZxWNgck=";

  meta = with lib; {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "csharpier";
  };
}
