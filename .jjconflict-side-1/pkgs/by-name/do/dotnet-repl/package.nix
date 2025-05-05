{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
}:

buildDotnetGlobalTool {
  pname = "dotnet-repl";
  version = "0.3.239";

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  nugetHash = "sha256-wn4i0zC56gxnjsgjdiMxLinmUsSROhmimu0lmBZo1hA=";

  meta = {
    description = "A polyglot REPL built on .NET Interactive";
    homepage = "https://github.com/jonsequitur/dotnet-repl";
    license = lib.licenses.mit;
    mainProgram = "dotnet-repl";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
