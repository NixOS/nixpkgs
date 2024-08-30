{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-tC2BZmjKeYjBfwJINtgVQEJjiqJidVtnXdxigFkR2/M=";
      hash_darwin_aarch64 =
        "sha256-MRXiiQPY8EZ85zRCmJyxuI7SG5RbalBBg+vt0goeWus=";
      hash_linux = "sha256-rQ/WYDghBXewFqMTGf7ZJGp2mMiPwjf8ImNyTvXulQU=";
      version = "128.0.6613.86";
    };
    deps = {
      gn = {
        hash = "sha256-BiMGbML5aNUt4JzzVqSszBj+8BMlEc92csNugo5qjUk=";
        rev = "b2afae122eeb6ce09c52d63f67dc53fc517dbdc8";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-11";
      };
    };
    hash = "sha256-wqhaK1VuE1qPLt+f/x2KrtwZGxKFluTOWYMau+cSl2E=";
    version = "128.0.6613.113";
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
