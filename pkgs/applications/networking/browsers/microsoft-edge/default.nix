{
  stable = import ./browser.nix {
    channel = "stable";
    version = "114.0.1823.79";
    revision = "1";
    sha256 = "sha256-17212c206c060f35f6dac70a77c2faeeec398a9a8dd5ef42ac2faa0024416518";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "115.0.1901.165";
    revision = "1";
    sha256 = "sha256-d8351690622d8acb0b1ad2403032873633033e1b1834a690549df4fad325928c";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "116.0.1938.10";
    revision = "1";
    sha256 = "sha256-3505da2e65fc02d2c458f924cc003dd177e615f970ba5c55447b4827e9f10a4e";
  };
}
