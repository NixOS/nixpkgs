{
  beta = import ./browser.nix {
    channel = "beta";
    version = "126.0.2592.53";
    revision = "1";
    hash = "sha256-d1zqZUhk5C/jrdZngQQlGplrSssE/LUR3/AybStNavE=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "127.0.2638.2";
    revision = "1";
    hash = "sha256-Bv0X30ilcNBI9pblnrO1QA7ElTPMO5/JmIZIjhldO7Y=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "125.0.2535.92";
    revision = "1";
    hash = "sha256-DuVz6+BzGTWZJ4smizIK2dV1OTmv0uTIQpD+yclHDN8=";
  };
}
