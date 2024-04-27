{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-RGOChK4JhrFUgVY/5YqgE0KFLRl6a7X2llw1ZfhiPXY=";
      hash_darwin_aarch64 =
        "sha256-K1jFXmWtXrS43UJg2mQ39Kae6tv7E9Fxm6LUWg+uwLo=";
      hash_linux = "sha256-xwaRNh7sllyNaq8+aLAZDQ3uDg06cu3KYqc02LWPSyw=";
      version = "124.0.6367.91";
    };
    deps = {
      gn = {
        hash = "sha256-aEL1kIhgPAFqdb174dG093HoLhCJ07O1Kpqfu7r14wQ=";
        rev = "22581fb46c0c0c9530caa67149ee4dd8811063cf";
        url = "https://gn.googlesource.com/gn";
        version = "2024-03-14";
      };
    };
    hash = "sha256-tajZtdiXgs5lRLTmDmgNTM2vD+N+LuWpBS0dYzxUsMA=";
    hash_deb_amd64 = "sha256-CyCbZQ5ce8WLTt2JVSqbDkLDboE4BloiZ8pJff3dmSY=";
    version = "124.0.6367.91";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-aEL1kIhgPAFqdb174dG093HoLhCJ07O1Kpqfu7r14wQ=";
        rev = "22581fb46c0c0c9530caa67149ee4dd8811063cf";
        url = "https://gn.googlesource.com/gn";
        version = "2024-03-14";
      };
      ungoogled-patches = {
        hash = "sha256-1/J3BhUlef8CH/jZ5P5fWGXnWxTiuB0Ep+AWrMrv9cE=";
        rev = "124.0.6367.91-1";
      };
    };
    hash = "sha256-tajZtdiXgs5lRLTmDmgNTM2vD+N+LuWpBS0dYzxUsMA=";
    hash_deb_amd64 = "sha256-CyCbZQ5ce8WLTt2JVSqbDkLDboE4BloiZ8pJff3dmSY=";
    version = "124.0.6367.91";
  };
}
