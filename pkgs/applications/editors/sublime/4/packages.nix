{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4126";
      x64sha256 = "sha256-XGTlNMzgAy5U08cCjo1rO97yjz/SiiYkSjYKLOdUUKE=";
      aarch64sha256 = "0gmnxyczj2wk9dilhkpa6gi2fkvbic6smyiimd3lq0s7ilbarm0a";
    } {};

    sublime4-dev = common {
      buildVersion = "4141";
      dev = true;
      x64sha256 = "eFo9v4hSrp1gV56adVyFB9sOApOXlKNvVBW0wbFYG4g=";
      aarch64sha256 = "MmwSptvSH507+X9GT8GC4tzZFzEfT2pKc+/Qu5SbMkM=";
    } {};
  }
