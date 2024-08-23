{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-4wp3nlGkuNDlmF+3bmJOmaMccQcsXBZaVO95Se6Vj1M=";
      hash_darwin_aarch64 =
        "sha256-La32ZBMgdWyl4nFoh4LfaxsoZJxrYkB/fbYOzltG8e8=";
      hash_linux = "sha256-qhoTtgPNrs2jMEVbVuVZAsQDygm72xfhWvhDC/mDUzc=";
      version = "128.0.6613.84";
    };
    deps = {
      gn = {
        hash = "sha256-BiMGbML5aNUt4JzzVqSszBj+8BMlEc92csNugo5qjUk=";
        rev = "b2afae122eeb6ce09c52d63f67dc53fc517dbdc8";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-11";
      };
    };
    hash = "sha256-kUHJtJ4X8UDMP2TgHdFd6gEPzU28mBgxtGceVZCl5xM=";
    version = "128.0.6613.84";
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
