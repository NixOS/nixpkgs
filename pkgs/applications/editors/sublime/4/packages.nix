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
      buildVersion = "4147";
      dev = true;
      x64sha256 = "9zs+2cp+pid0y/v5tHJN4jp7sM1oGB5EgGzMASL3y4o=";
      aarch64sha256 = "KyvHJPqBEfeQQJnuyWZA7vGhWkYFqMaTMx+uy+3cZ30=";
    } {};
  }
