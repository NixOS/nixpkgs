{
  beta = import ./browser.nix {
    channel = "beta";
    version = "126.0.2592.24";
    revision = "1";
    hash = "sha256-OK38ss0M+GNP/wKLVheyKBgji3Df/qyrxaKvJayNZMM=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "126.0.2592.11";
    revision = "1";
    hash = "sha256-hUeVnGN5lxZmNsYojt7Fl0n7XF76Arw8Z3C16+fHRVA=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "125.0.2535.67";
    revision = "1";
    hash = "sha256-82bkiyKWJqVLB4jBaGu4EdJ0ukl44yKopDecAkrzuU0=";
  };
}
