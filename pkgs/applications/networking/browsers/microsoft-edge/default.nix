{
  beta = import ./browser.nix {
    channel = "beta";
    version = "126.0.2592.68";
    revision = "1";
    hash = "sha256-ThWtnWF7iL0OEq7+yA7vCowGZrjeiLx+d+Nff4Bwl4s=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "127.0.2651.2";
    revision = "1";
    hash = "sha256-eYCxGMIjclqFxOy6AyLKN5DJnplq/Vf3ClYbYWV3HAw=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "126.0.2592.68";
    revision = "1";
    hash = "sha256-btpUMmgZ9SQL4WGKynGA/dL/8Ve9hdjoDNsBNxG531Y=";
  };
}
