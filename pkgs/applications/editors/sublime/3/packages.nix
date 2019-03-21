{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  rec {
    sublime3-dev = common {
      buildVersion = "3184";
      dev = true;
      x32sha256 = "1b6f1fid75g5z247dbnyyj276lrlv99scrdk1vvfcr6vyws77vzr";
      x64sha256 = "03127jhfjr17ai96p3axh5b5940fds8jcw6vkid8y6dmvd2dpylz";
    } {};

    sublime3 = common {
      buildVersion = "3200";
      x32sha256 = "01krmbji8z62x4kl1hf3c1nfj4c4n4xmg1df62ljiwhkcfm74izr";
      x64sha256 = "1gagc50fqb0d2bszi8m5spzb64shkaylvrwl6fxah55xcmy2kmdr";
    } {};
  }
