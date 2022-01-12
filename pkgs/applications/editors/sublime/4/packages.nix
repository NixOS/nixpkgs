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
      buildVersion = "4125";
      dev = true;
      x64sha256 = "sha256-+WvLkA7sltJadfm704rOECU4LNoVsv8rDmoAlO/M6Jo=";
      aarch64sha256 = "11rbdy9rsn5b39qykbws4dqss89snrik7c2vdiw9cj0kibglsc3f";
    } {};
  }
