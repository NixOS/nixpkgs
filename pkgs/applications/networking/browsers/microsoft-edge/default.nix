{
  beta = import ./browser.nix {
    channel = "beta";
    version = "108.0.1462.20";
    revision = "1";
    sha256 = "sha256:0dfmzjfy4y07pqifyzv3rc8dbmxz8rr3v2idanla7jrks0pghcxm";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "109.0.1495.2";
    revision = "1";
    sha256 = "sha256:1bk7dx3mf020ahzmvr9cdgcn72rjrn2420j9g362vwcl1khyxciw";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "107.0.1418.52";
    revision = "1";
    sha256 = "sha256:1k3c5r9lq3vpc190bzs5fn944bi3af6wjxzwcliy4wzzrb5g0day";
  };
}
