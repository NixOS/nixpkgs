{
  beta = import ./browser.nix {
    channel = "beta";
    version = "101.0.1210.19";
    revision = "1";
    sha256 = "sha256:1kgc19ryw69xiqppz90d6sa45g99hzkh7x5yk9d3xlh1gc1xn54p";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "102.0.1227.0";
    revision = "1";
    sha256 = "sha256:0dnyandri7yg7c9812pnsxqszxyqcssxf87yskjg2vw95hawf11x";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "100.0.1185.44";
    revision = "1";
    sha256 = "sha256:0zv1zyijh620xz36a6nmhv7rbv4ln5f245hyh0w1sngynsl1rz89";
  };
}
