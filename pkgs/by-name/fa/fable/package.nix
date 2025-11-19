{
  buildDotnetGlobalTool,
  lib,
  testers,
}:

buildDotnetGlobalTool (finalAttrs: {
  pname = "fable";
  version = "4.27.0";

  nugetHash = "sha256-AUkno8RzqWsDJxmf+1ey+BlCRP5kuQSeZW7xim5YpgY=";

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
