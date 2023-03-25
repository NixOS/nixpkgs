{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.12.0";
    hash = "sha256-nhUrxwcE53QG2akSHCFKJR62ydwZ7d4LI+l4o1bgKJo=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.13.0-beta.1";
    hash = "sha256-An76VcyuDvTVgXL8sVx0El5EognReiiUBTbRxNmMOrQ=";
  };
}
