{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.1.0";
    hash = "sha256-70IQ/2yjHbez8SpZxqZKa/XWIEYA3cN7JAIM9kgjN30=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.2.0-beta.2";
    hash = "sha256-NVwX2xG8QGVjENy6fSA13WQyTlYuF5frcS3asDDg4Ik=";
  };
}
