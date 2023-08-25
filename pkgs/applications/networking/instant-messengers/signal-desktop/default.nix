{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.27.1";
    hash = "sha256-nEOt6bep6SqhAab8yD9NlRrDGU2IvZeOxSqPj2u1bio=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.24.0-beta.1";
    hash = "sha256-tA1xsgtAeOn0c0HcZutj+Pqrsr0JV5bQOnknH4t/QkY=";
  };
}
