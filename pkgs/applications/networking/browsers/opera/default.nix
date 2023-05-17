{
  stable = import ./browser.nix {
    channel = "stable";
    channelRoot = "opera/desktop";
    version = "100.0.4815.30";
    sha256 = "sha256-7JWN6SAqkrQeYAFU9IAgyr4kjS7FkTpX+qnn6wnfc7Q=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    channelRoot = "opera-beta";
    version = "101.0.4843.5";
    sha256 = "sha256-/ZzhfPtMB+cAPiQ8PnIJDlJU8kkAZ2Qi2LXHQj1arog=";
  };
  developer = import ./browser.nix {
    channel = "developer";
    channelRoot = "opera-developer";
    version = "101.0.4843.0";
    sha256 = "sha256-F31ybVEOQ6tJtsnZfQ9zi+Lphdw67s7SF1MRjwPBWdI=";
  };
}
