{
  buildDotnetGlobalTool,
  lib,
  testers,
}:

buildDotnetGlobalTool (finalAttrs: {
  pname = "fable";
<<<<<<< HEAD
  version = "4.28.0";

  nugetHash = "sha256-t5Kex6sVe1B/xErMfDav+WGEjeZjndRNQA2r0FvL92g=";
=======
  version = "4.26.0";

  nugetHash = "sha256-nhIGVwu6kHTW+t0hiD1Pha3+ErE5xACBrVDgFP6qMnc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
