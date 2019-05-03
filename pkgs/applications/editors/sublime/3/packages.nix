{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  rec {
    sublime3-dev = common {
      buildVersion = "3208";
      dev = true;
      x32sha256 = "09k04fjryc0dc6173i6nwhi5xaan89n4lp0n083crvkqwp0qlf2i";
      x64sha256 = "12pn3yfm452m75dlyl0lyf82956j8raz2dglv328m81hbafflrj8";
    } {};

    sublime3 = common {
      buildVersion = "3200";
      x32sha256 = "01krmbji8z62x4kl1hf3c1nfj4c4n4xmg1df62ljiwhkcfm74izr";
      x64sha256 = "1gagc50fqb0d2bszi8m5spzb64shkaylvrwl6fxah55xcmy2kmdr";
    } {};
  }
