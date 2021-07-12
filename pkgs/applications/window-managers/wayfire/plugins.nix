{ newScope, wayfire }:

let
  self = with self; {
    inherit wayfire;

    callPackage = newScope self;

    wf-shell = callPackage ./wf-shell.nix { };
  };
in
self
