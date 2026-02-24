{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
}:

buildDotnetGlobalTool {
  pname = "dotnet-repl";
  version = "0.3.250";

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  nugetHash = "sha256-Tja6kIr9nHMrFY76vdFvS3ig2Tfrjus8mJb+2OC8fnk=";

  meta = {
    description = "Polyglot REPL built on .NET Interactive";
    homepage = "https://github.com/jonsequitur/dotnet-repl";
    license = lib.licenses.mit;
    mainProgram = "dotnet-repl";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
