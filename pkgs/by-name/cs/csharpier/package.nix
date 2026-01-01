{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
<<<<<<< HEAD
  version = "1.2.4";
  executables = "csharpier";

  nugetHash = "sha256-kgVQpFxQmMT/eoWkGyA8A0z//p7VponlyYF+CV7Txs8=";

  meta = {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zoriya ];
=======
  version = "1.2.1";
  executables = "csharpier";

  nugetHash = "sha256-JJS/jlUM2GRYKPzsIbAnRM8Jhr8/Mr6Nlmjtq9TMBuc=";

  meta = with lib; {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zoriya ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "csharpier";
  };
}
