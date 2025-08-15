{
  buildDotnetGlobalTool,
  lib,
}:

buildDotnetGlobalTool {
  pname = "fsharplint";
  nugetName = "dotnet-fsharplint";
  version = "0.26.1--date20250813-0925.git-2155f74";
  executables = "dotnet-fsharplint";
  nugetHash = "sha256-ZJoF8KoOVT0EZd24yE2mSnHEK+XHxXXuP/2+hPTDiQQ=";
  useDotnetFromEnv = true;
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
