{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-PmLV++FK6aCvdhNNhb2ZAmRLumr+VRFvN+7IByieEZk=";
      hash_darwin_aarch64 =
        "sha256-6Ys1EMSLmJNNaWdPeQiCT+bC0H7ABInVNzwXorGavn4=";
      hash_linux = "sha256-iimq37dcEcY2suW73a6lhgHuNaoqtzbAZCHkQP9ro/Y=";
      version = "123.0.6312.122";
    };
    deps = {
      gn = {
        hash = "sha256-aEL1kIhgPAFqdb174dG093HoLhCJ07O1Kpqfu7r14wQ=";
        rev = "22581fb46c0c0c9530caa67149ee4dd8811063cf";
        url = "https://gn.googlesource.com/gn";
        version = "2024-03-14";
      };
    };
    hash = "sha256-apEniFKhIxPo4nhp9gCU+WpiV/EB40qif4RfE7Uniog=";
    hash_deb_amd64 = "sha256-rSbigG5/xbL32d1ntOn6gnZyxSpgrg1h7lb/RD4YROI=";
    version = "124.0.6367.60";
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
        hash = "sha256-zgkt0stU/H5Mji429tigVbjOq27Op8UppHTjG6neoeA=";
        rev = "124.0.6367.60-1";
      };
    };
    hash = "sha256-apEniFKhIxPo4nhp9gCU+WpiV/EB40qif4RfE7Uniog=";
    hash_deb_amd64 = "sha256-rSbigG5/xbL32d1ntOn6gnZyxSpgrg1h7lb/RD4YROI=";
    version = "124.0.6367.60";
  };
}
