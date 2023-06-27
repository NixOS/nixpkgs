{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.21.0";
    hash = "sha256-MDjh2slEmGCMn0Q4YsIzVQO2I7ZE5XUJX5qH4OYFFxw=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.22.0-beta.3";
    hash = "sha256-Obc7JHfsFrkJkcgm/i9/6hDsoHczqz7txg4W+u/Jems=";
  };
}
