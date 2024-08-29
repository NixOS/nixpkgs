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
        hash = "sha256-BiMGbML5aNUt4JzzVqSszBj+8BMlEc92csNugo5qjUk=";
        rev = "b2afae122eeb6ce09c52d63f67dc53fc517dbdc8";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-11";
      };
      ungoogled-patches = {
        hash = "sha256-2P9c+zS741H4/jTp92mno4egju9r0tGTLkXHAFhM9mA=";
        rev = "128.0.6613.113-1";
      };
    };
    hash = "sha256-wqhaK1VuE1qPLt+f/x2KrtwZGxKFluTOWYMau+cSl2E=";
    version = "128.0.6613.113";
  };
}
