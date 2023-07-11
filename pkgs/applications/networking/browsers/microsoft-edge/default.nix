{
  stable = import ./browser.nix {
    channel = "stable";
    version = "114.0.1823.79";
    revision = "1";
    sha256 = "sha256-17212c206c060f35f6dac70a77c2faeeec398a9a8dd5ef42ac2faa0024416518";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "114.0.1823.24";
    revision = "1";
    sha256 = "sha256-AT3jkuNXcVoKx98BJtONm06oO/kUyV0E7DVvkzPOfGE=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "115.0.1851.0";
    revision = "1";
    sha256 = "sha256-PmfMe+B/JtvPhBGhQBUgoWjhKokTwCdG9y+GYl0VCMk=";
  };
}
