<<<<<<< HEAD
{ lib, pkgs }:

lib.makeScope pkgs.newScope (self:
  let
    inherit (self) callPackage;
  in {
    wayfire-plugins-extra = callPackage ./wayfire-plugins-extra.nix { };
    wcm = callPackage ./wcm.nix { };
    wf-shell = callPackage ./wf-shell.nix { };
  }
)
=======
{ newScope, wayfire }:

let
  self = with self; {
    inherit wayfire;

    callPackage = newScope self;

    wf-shell = callPackage ./wf-shell.nix { };
  };
in
self
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
