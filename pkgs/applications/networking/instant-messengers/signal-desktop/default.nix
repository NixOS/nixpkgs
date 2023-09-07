{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.30.1";
    hash = "sha256-tG5R4A+Uz/ynw0cD7tW5/Fp8KlnNk+zmnRp01m/6vZU=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.30.0-beta.2";
    hash = "sha256-EMgstKlHA6ilSlbDmsPAu/jNC21XGzF7LS7QzWcK2F0";
  };
}
