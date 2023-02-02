{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.4.1";
    hash = "sha256-/Rrph74nVr64Z6blNNn3oMM25YK92MZY/vuF1d+r6Yc=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.4.0-beta.1";
    hash = "sha256-GR7RWFT20i5dx6XYrp73inCOQ2Hj2UjSXf5jmjfDKMU=";
  };
}
