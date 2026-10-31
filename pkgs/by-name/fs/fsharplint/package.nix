{
  buildDotnetGlobalTool,
  lib,
}:

buildDotnetGlobalTool {
  pname = "fsharplint";
  nugetName = "dotnet-fsharplint";
  version = "0.27.0";
  executables = "dotnet-fsharplint";
  nugetHash = "sha256-VXgCDoQad1p8K1zyw4ZynqwX8UB7F6NLXh13DafzYGw=";
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
