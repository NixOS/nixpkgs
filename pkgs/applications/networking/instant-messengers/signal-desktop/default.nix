{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.14.0";
    hash = "sha256-dy/qzOv3x+nv3tIwHJUQ2BIwUNsvGbsKZOZxkgD3270=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.11.0-beta.2";
    hash = "sha256-tw8VsPC0shKIN13ICD0PVKhKxA7rdj16r2lP2UEJGsY=";
  };
}
