{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
}:

buildDotnetGlobalTool {
  pname = "dotnet-repl";
  version = "0.3.247";

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  nugetHash = "sha256-nD5GqLG+3VAWMy/8E9XviwJq2wKBg+BISlcB4xWtrx4=";

  meta = {
    description = "Polyglot REPL built on .NET Interactive";
    homepage = "https://github.com/jonsequitur/dotnet-repl";
    license = lib.licenses.mit;
    mainProgram = "dotnet-repl";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
