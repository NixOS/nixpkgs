{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.36.0";
    hash = "sha256-zoeRBBu+eYWibpCUiyDOcDVKFQSRI+l1dZgUlESdUsk=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.36.0-beta.2";
    hash = "sha256-LOfKdyXosU0bJB35+TSszfHROPhLvMtngzy4zFeVVmI=";
  };
}
