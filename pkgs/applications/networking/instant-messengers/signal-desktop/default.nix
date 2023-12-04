{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.40.0";
    hash = "sha256-vyXHlycPSyEyv938IKzGM6pdERHHerx2CLY/U+WMrH4=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.40.0-beta.2";
    hash = "sha256-pfedkxbZ25DFgz+/N7ZEb9LwKrHuoMM+Zi+Tc21QPsg=";
  };
}
