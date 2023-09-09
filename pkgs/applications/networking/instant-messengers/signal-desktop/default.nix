{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.30.1";
    hash = "sha256-tG5R4A+Uz/ynw0cD7tW5/Fp8KlnNk+zmnRp01m/6vZU=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.31.0-beta.1";
    hash = "sha256-j3DY+FY7kVVGvVuVZw/JxIpwxtgBttSyWcRaa9MCSjE=";
  };
}
