{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4143";
      x64sha256 = "fehiw40ZNnQUEXEQMo3e11SscJ/tVMjMXLBzfIlMBzw=";
      aarch64sha256 = "4zpNHVEHO98vHcWTbqmwlrB4+HIwoQojeQvq7nAqSpM=";
    } {};

    sublime4-dev = common {
      buildVersion = "4149";
      dev = true;
      x64sha256 = "heP37UBUNula8RV82tSXwKAYwi2DNubHASD2FcLRkjs=";
      aarch64sha256 = "u1KUI+st/+T9tNVh+u9+5ZSQIj26YyXGtQRrjB+paOQ=";
    } {};
  }
