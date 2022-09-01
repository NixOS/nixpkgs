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
      buildVersion = "4134";
      dev = true;
      x64sha256 = "rd3EG8e13FsPKihSM9qjUMRsEA6joMwVqhj1NZlwIaE=";
      aarch64sha256 = "gdfEDd2E1sew08sVmcmw21zyil8JuJJMpG2T/9Pi81E=";
    } {};
  }
