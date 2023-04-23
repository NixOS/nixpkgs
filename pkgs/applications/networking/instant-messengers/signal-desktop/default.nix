{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.15.0";
    hash = "sha256-uZXFnbDe49GrjKm4A0lsOTGV8Xqg0+oC0+AwRMKykfY=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.16.0-beta.1";
    hash = "sha256-J7YPuQetfob8Ybab+c5W0Z4Urzi4AtEJAnIVRIGtv0Q=";
  };
}
