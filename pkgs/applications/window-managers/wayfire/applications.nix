{ newScope, wayfirePlugins }:

let
  self = with self; {
    inherit wayfirePlugins;

    callPackage = newScope self;

    wayfire = callPackage ./. { };

    wcm = callPackage ./wcm.nix {
      inherit (wayfirePlugins) wf-shell;
    };

    wrapWayfireApplication = callPackage ./wrapper.nix { };

    withPlugins = selector: self // {
      wayfire = wrapWayfireApplication wayfire selector;
      wcm = wrapWayfireApplication wcm selector;
    };
  };
in
self
