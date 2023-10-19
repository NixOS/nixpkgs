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
      buildVersion = "4155";
      dev = true;
      x64sha256 = "owcux1/CjXQsJ8/6ex3CWV1/Wvh/ofZFH7yNQtxl9d4=";
      aarch64sha256 = "YAcdpBDmaajQPvyp8ypJNom+XOKx2YKA2uylfxlKuZY=";
    } {};
  }
