{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4142";
      x64sha256 = "JrFL17trcsUcS/bYbSbMhTnSMyla6AkoMII2lt2nAwY=";
      aarch64sha256 = "r6bxOYXVA2RAo8prdBQ7/gSNKFPmwDW5osblIE0azT4=";
    } {};

    sublime4-dev = common {
      buildVersion = "4141";
      dev = true;
      x64sha256 = "eFo9v4hSrp1gV56adVyFB9sOApOXlKNvVBW0wbFYG4g=";
      aarch64sha256 = "MmwSptvSH507+X9GT8GC4tzZFzEfT2pKc+/Qu5SbMkM=";
    } {};
  }
