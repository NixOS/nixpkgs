{ callPackage, buildNpmPackage }:

let
  electron-bin = callPackage ./castlabs-electron-bin { };

  inherit (electron-bin) electron_24-bin;

  bindings = callPackage ./node-bindings { };
  register-scheme = callPackage ./node-register-scheme { inherit bindings; };
  electron = callPackage ./castlabs-electron { electron = electron_24-bin; };
in
{
  inherit electron_24-bin bindings register-scheme electron;
}
