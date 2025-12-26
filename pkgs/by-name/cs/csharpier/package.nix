{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "csharpier";
  version = "1.2.3";
  executables = "csharpier";

  nugetHash = "sha256-mUpciGlqLVkQW+V1KEe1/p99cy4+NYCG8PGYSynNhbs=";

  meta = {
    description = "Opinionated code formatter for C#";
    homepage = "https://csharpier.com/";
    changelog = "https://github.com/belav/csharpier/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zoriya ];
    mainProgram = "csharpier";
  };
}
