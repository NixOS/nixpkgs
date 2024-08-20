{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-z+08R1CYi53edNEDSvJ303+hc/pqiFvVhUkD+g4q6tE=";
      hash_darwin_aarch64 =
        "sha256-q60NWIka3QzLsWg3X/+qTWby6UTf7wvjCDdZWlUjzPA=";
      hash_linux = "sha256-6E6LaQCx+2Xd/vjjaiQR3vJgkP7L4MRkA7Bb0jTrakc=";
      version = "127.0.6533.119";
    };
    deps = {
      gn = {
        hash = "sha256-vzZu/Mo4/xATSD9KgKcRuBKVg9CoRZC9i0PEajYr4UM=";
        rev = "b3a0bff47dd81073bfe67a402971bad92e4f2423";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-06";
      };
    };
    hash = "sha256-LuUDEpYCJLR/X+zjsF26aum4/Wfu2MNowofPu8iRVxI=";
    version = "127.0.6533.119";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-vzZu/Mo4/xATSD9KgKcRuBKVg9CoRZC9i0PEajYr4UM=";
        rev = "b3a0bff47dd81073bfe67a402971bad92e4f2423";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-06";
      };
      ungoogled-patches = {
        hash = "sha256-m7x7tPrJfddPER9uiSp983xGn3YSH+Bq01l14vOlwrU=";
        rev = "127.0.6533.119-2";
      };
    };
    hash = "sha256-LuUDEpYCJLR/X+zjsF26aum4/Wfu2MNowofPu8iRVxI=";
    version = "127.0.6533.119";
  };
}
