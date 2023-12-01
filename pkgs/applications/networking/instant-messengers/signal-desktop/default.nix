{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.39.1";
    hash = "sha256-dDbUpxXpQg1SoVyYO33Nczqf+WmWDPNE6cmw792wjGY=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.40.0-beta.2";
    hash = "sha256-pfedkxbZ25DFgz+/N7ZEb9LwKrHuoMM+Zi+Tc21QPsg=";
  };
}
