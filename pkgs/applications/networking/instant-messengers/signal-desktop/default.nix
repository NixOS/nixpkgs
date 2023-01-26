{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.3.0";
    hash = "sha256-Mg7znebHiREC9QI5T7bWT4QXL8biDVBp0Z6Jgeid/gY=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.2.0-beta.2";
    hash = "sha256-NVwX2xG8QGVjENy6fSA13WQyTlYuF5frcS3asDDg4Ik=";
  };
}
