{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.39.0";
    hash = "sha256-cG8ZFWpx92haTgMkpMMcFDV0OB7lmU540g9fNj4ofy8=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.40.0-beta.1";
    hash = "sha256-daXh1Uh2lHw0NA/j7qhQK7nrVljbr/fP2iLjcqnuvns=";
  };
}
