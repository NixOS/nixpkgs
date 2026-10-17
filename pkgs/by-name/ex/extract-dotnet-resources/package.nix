{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
}:
buildDotnetModule {
  name = "extract-dotnet-resources";

  src = ./.;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  nugetDeps = ./deps.json;

  meta = {
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ js6pak ];
    mainProgram = "extract-dotnet-resources";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
}
