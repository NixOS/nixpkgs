{
  buildDotnetGlobalTool,
  dotnetCorePackages,
  lib,
  testers,
}:

buildDotnetGlobalTool (finalAttrs: {
  pname = "fable";
  version = "5.18.0";

  nugetHash = "sha256-zaa7UJnn5IM7fhGUBmogRUDe/2rpH79UR+k6dym7kmQ=";

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  passthru.tests = testers.testVersion {
    package = finalAttrs.finalPackage;
    # the version is written with an escape sequence for colour, and I couldn't
    # find a way to disable it
    version = "[37m${finalAttrs.version}";
  };

  meta = {
    description = "F# to JavaScript compiler";
    mainProgram = "fable";
    homepage = "https://github.com/fable-compiler/Fable";
    changelog = "https://github.com/fable-compiler/Fable/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      anpin
      mdarocha
    ];
  };
})
