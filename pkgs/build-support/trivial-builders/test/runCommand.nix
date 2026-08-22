{ lib, runCommand, ... }:

lib.recurseIntoAttrs {

  runCommandBasic = runCommand "hi" { greeting = "hello"; } ''
    [[ $greeting == hello ]] || echo wtf
    touch $out
  '';

  runCommandFinalAttrs =
    runCommand "hi-finalAttrs"
      (finalAttrs: {
        message = finalAttrs.greeting;
        greeting = "hello";
      })
      (
        finalAttrs:
        assert finalAttrs.message == "hello";
        ''
          [[ $message == hello ]] || echo wtf
          touch $out
        ''
      );

}
