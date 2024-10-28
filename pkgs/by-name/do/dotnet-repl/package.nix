{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
}:

buildDotnetGlobalTool {
  pname = "dotnet-repl";
  version = "0.1.216";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetHash = "sha256-JHatCW+hl2792S+HYeEbbYbCIS+N4DmOctqXB/56/HU=";

  meta = {
    description = "A polyglot REPL built on .NET Interactive";
    homepage = "https://github.com/jonsequitur/dotnet-repl";
    license = lib.licenses.mit;
    mainProgram = "dotnet-repl";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
