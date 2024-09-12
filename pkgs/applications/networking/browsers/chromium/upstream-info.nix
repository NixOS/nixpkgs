{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-UtBJZG+pRdqwxWsvuxYrRJsmFdMEa5h6lWXt39cPxF0=";
      hash_darwin_aarch64 =
        "sha256-2HFrIwc8Jzlg6/eKkJqfd8kwS8c6powU2RnpBGMSBak=";
      hash_linux = "sha256-8EEJL0A/t0VabaKHEHC2WHwygUo+PCsKeU09SqRzkVE=";
      version = "128.0.6613.137";
    };
    deps = {
      gn = {
        hash = "sha256-BiMGbML5aNUt4JzzVqSszBj+8BMlEc92csNugo5qjUk=";
        rev = "b2afae122eeb6ce09c52d63f67dc53fc517dbdc8";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-11";
      };
    };
    hash = "sha256-/q+Z1a1EFZRQvC3pmuDbzJWzSSYkI7bfgUAaJRBaj00=";
    version = "128.0.6613.137";
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
        hash = "sha256-o/cEVLD64qYd/VIbmN/FCFbu7LgQsZdWkyxIns7/bRs=";
        rev = "128.0.6613.137-1";
      };
    };
    hash = "sha256-/q+Z1a1EFZRQvC3pmuDbzJWzSSYkI7bfgUAaJRBaj00=";
    version = "128.0.6613.137";
  };
}
