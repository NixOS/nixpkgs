{
  buildDotnetGlobalTool,
  dotnetCorePackages,
  lib,
  testers,
}:

buildDotnetGlobalTool (finalAttrs: {
  pname = "fable";
  version = "5.0.0";

  nugetHash = "sha256-PSlr4cGZAm/bgAesVn7dYqamvncat8lm1/lJHvYcAwk=";

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
    homepage = "https://github.com/fable-compiler/fable";
    changelog = "https://github.com/fable-compiler/fable/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      anpin
      mdarocha
    ];
  };
})
