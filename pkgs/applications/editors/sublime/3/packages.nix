{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  rec {
    sublime3-dev = common {
      buildVersion = "3176";
      x32sha256 = "08asz13888d4ddsz81cfk7k3319dabzz1kgbnshw0756pvyrvr23";
      x64sha256 = "0cppkh5jx2g8f6jyy1bs81fpb90l0kn5m7y3skackpjdxhd7rwbl";
    } {};

    sublime3 = common {
      buildVersion = "3176";
      x32sha256 = "08asz13888d4ddsz81cfk7k3319dabzz1kgbnshw0756pvyrvr23";
      x64sha256 = "0cppkh5jx2g8f6jyy1bs81fpb90l0kn5m7y3skackpjdxhd7rwbl";
    } {};
  }
