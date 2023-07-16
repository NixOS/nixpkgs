{ newScope, wayfire }:

let
  self = with self; {
    inherit wayfire;

    callPackage = newScope self;

    wf-shell = callPackage ./wf-shell.nix { };
    wayfire-plugins-extra = callPackage ./wayfire-plugins-extra.nix { };
  };
in
self
