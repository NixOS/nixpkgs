{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.10.1";
    hash = "sha256-uWwRgP9iYirZU9x3QtS5lRGI7vLOOtX4B4fgVuYxkho=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.10.0-beta.1";
    hash = "sha256-A8jpYDWiCCBadRDzmNVxzucKPomgXlqdyeGiYp+1Byo=";
  };
}
