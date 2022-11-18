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
      buildVersion = "4141";
      dev = true;
      x64sha256 = "eFo9v4hSrp1gV56adVyFB9sOApOXlKNvVBW0wbFYG4g=";
      aarch64sha256 = "MmwSptvSH507+X9GT8GC4tzZFzEfT2pKc+/Qu5SbMkM=";
    } {};
  }
