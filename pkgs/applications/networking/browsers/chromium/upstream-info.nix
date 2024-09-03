{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-jqBrEpqHRjpxi7sp/dSzQFzROS21bPTfwvco/UzKMug=";
      hash_darwin_aarch64 =
        "sha256-7T9uargLSXs4uqBmS00eUNvhYiA42UC7DPTkTI2sM8U=";
      hash_linux = "sha256-Li4f3+zZl2HCbxwIyLpylRJ1PMRbV3LKW7dBEnKyIdo=";
      version = "128.0.6613.119";
    };
    deps = {
      gn = {
        hash = "sha256-BiMGbML5aNUt4JzzVqSszBj+8BMlEc92csNugo5qjUk=";
        rev = "b2afae122eeb6ce09c52d63f67dc53fc517dbdc8";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-11";
      };
    };
    hash = "sha256-WCemrL5jPRn5P1olLwfrAM1xLc0hcaBYDj0CZPoPucU=";
    version = "128.0.6613.119";
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
        hash = "sha256-qHt7Rjx1VmKlX8ko7hpNv8SW/rNhXsGchWs6A/aXuu0=";
        rev = "128.0.6613.119-1";
      };
    };
    hash = "sha256-WCemrL5jPRn5P1olLwfrAM1xLc0hcaBYDj0CZPoPucU=";
    version = "128.0.6613.119";
  };
}
