{
  stable = import ./browser.nix {
    channel = "stable";
    version = "113.0.1774.42";
    revision = "1";
    sha256 = "sha256-gd9ub3WppnYuK7Ul57r66+ioYHCopz8MoDdxqWb3Ukg=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "114.0.1823.18";
    revision = "1";
    sha256 = "sha256-58oe/82jad0v+cqR1l5NZjdAI0EJDyICMR1l6z2DLsE=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "115.0.1851.0";
    revision = "1";
    sha256 = "sha256-PmfMe+B/JtvPhBGhQBUgoWjhKokTwCdG9y+GYl0VCMk=";
  };
}
