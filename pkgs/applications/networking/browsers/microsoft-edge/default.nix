{
  stable = import ./browser.nix {
    channel = "stable";
    version = "113.0.1774.50";
    revision = "1";
    sha256 = "sha256-5QKIVh/y3CBPlWUbrudvC2NHfJGB5nGsu/4tUfCOCYM=";
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
