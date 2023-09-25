{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.30.2";
    hash = "sha256-qz3eO+pTLK0J+XjAccrZIJdyoU1zyYyrnpQKeLRZvc8=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.32.0-beta.1";
    hash = "sha256-7G4vjnEQnYOIVwXmBt1yZULvDaWXWTDgZCLWCZUq2Gs=";
  };
}
