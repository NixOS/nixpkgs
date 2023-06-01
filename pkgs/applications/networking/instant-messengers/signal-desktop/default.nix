{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.17.1";
    hash = "sha256-9m9+waQgQQk/7T7d4UZY3PqgPEhseaXmI8lZ5oiI92A=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.18.0-beta.2";
    hash = "sha256-qfBc1+XwHbD/FAGLezmgOJsAYn4ZTuGU4w1aR8g/2U0=";
  };
}
