{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "1.2.1";
  executables = "csharpier";

  nugetHash = "sha256-JJS/jlUM2GRYKPzsIbAnRM8Jhr8/Mr6Nlmjtq9TMBuc=";

  meta = with lib; {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
    mainProgram = "csharpier";
  };
}
