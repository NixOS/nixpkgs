{ lib, callPackage }:
lib.makeOverridable (
  args:
  let
    buildFHSEnv = callPackage ./buildFHSEnv.nix { };
    fhsenv = buildFHSEnv (
      lib.attrsets.removeAttrs args [
        "runScript"
        "extraInstallCommands"
        "meta"
        "passthru"
        "extraPreBwrapCmds"
        "extraBwrapArgs"
        "dieWithParent"
        "unshareUser"
        "unshareCgroup"
        "unshareUts"
        "unshareNet"
        "unsharePid"
        "unshareIpc"
        "privateTmp"
      ]
    );

    wrapper = callPackage ./wrapper.nix { };
  in
  wrapper fhsenv args
)
