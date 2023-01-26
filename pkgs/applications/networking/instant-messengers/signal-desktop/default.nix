{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.3.0";
    hash = "sha256-Mg7znebHiREC9QI5T7bWT4QXL8biDVBp0Z6Jgeid/gY=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.4.0-beta.1";
    hash = "sha256-GR7RWFT20i5dx6XYrp73inCOQ2Hj2UjSXf5jmjfDKMU=";
  };
}
