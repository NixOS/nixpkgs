{
  buildDotnetGlobalTool,
  lib,
}:

buildDotnetGlobalTool {
  pname = "fsharplint";
  nugetName = "dotnet-fsharplint";
  version = "0.27.2";
  executables = "dotnet-fsharplint";
  nugetHash = "sha256-OVA/e/VD7pkWvHe0ZlBFD+xPw9AiZM0qf3TRWfrcRu4=";
  useDotnetFromEnv = true;
  strictDeps = true;
  __structuredAttrs = true;
  meta = {
    description = "Lint tool for F#";
    homepage = "https://github.com/fsprojects/FSharpLint";
    changelog = "https://github.com/fsprojects/FSharpLint/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sharpchen ];
    mainProgram = "dotnet-fsharplint";
  };
}
