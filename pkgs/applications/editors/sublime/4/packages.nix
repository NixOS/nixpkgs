{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4152";
      x64sha256 = "bt48g1GZWYlwQcZQboUHU8GZYmA7cb2fc6Ylrh5NNVQ=";
      aarch64sha256 = "nSH5a5KRYzqLMnLo2mFk3WpjL9p6Qh3zNy8oFPEHHoA=";
    } {};

    sublime4-dev = common {
      buildVersion = "4168";
      dev = true;
      x64sha256 = "KfW1Mh78CUBTmthHQd1s15a7GrmssSnWZ1RgaarJeag=";
      aarch64sha256 = "qJ9oix1kwWN+TUb5/WSKyHcHzB+Q87XolMOhmqx1OFc=";
    } {};
  }
