{
  buildDotnetGlobalTool,
  lib,
  testers,
}:

buildDotnetGlobalTool (finalAttrs: {
  pname = "fable";
  version = "4.29.0";

  nugetHash = "sha256-Eed1bb9heteWOWmv6NnXPzXbf3t218K/eHufwgtRuzI=";

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
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      anpin
      mdarocha
    ];
  };
})
