{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  rec {
    sublime3-dev = common {
      buildVersion = "3203";
      dev = true;
      x32sha256 = "builder for '/nix/store/r17nxj6c8cchi1vz498yg8a6z2ghilaf-sublimetext-3203.tar.bz2.drv' failed due to signal 31 (Bad system call)";
      x64sha256 = "0dp4vi39s2gq5a7snz0byrf44i0csbzwq6hn7i2zqa6rpvfywa1d";
    } {};

    sublime3 = common {
      buildVersion = "3200";
      x32sha256 = "01krmbji8z62x4kl1hf3c1nfj4c4n4xmg1df62ljiwhkcfm74izr";
      x64sha256 = "1gagc50fqb0d2bszi8m5spzb64shkaylvrwl6fxah55xcmy2kmdr";
    } {};
  }
