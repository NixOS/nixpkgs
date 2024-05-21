{
  beta = import ./browser.nix {
    channel = "beta";
    version = "125.0.2535.51";
    revision = "1";
    hash = "sha256-ZOuC4+1Vp+i/vA783h+ilz97YwPwLMwk5eoc2hR5Y9E=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "126.0.2578.1";
    revision = "1";
    hash = "sha256-L1w8d0IdqCps7BuyL3AWMzPPkZtwLuiA+Z/dWSlEJU8=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "125.0.2535.51";
    revision = "1";
    hash = "sha256-bpI3ePjjJLAoF/+ygXWYV1RY/FxOjs6/V8N0XWcal70=";
  };
}
