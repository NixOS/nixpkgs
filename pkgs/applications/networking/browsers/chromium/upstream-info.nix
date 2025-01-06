{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-YndBzhUNmn5tJdCqLmpUrs2WBXXpTxiKCNczWEz6DU4=";
      hash_darwin_aarch64 =
        "sha256-taG58kMgQUD40aGqnyx9O9e9m4qGsTWX57cjD3NeHm4=";
      hash_linux = "sha256-raWGzhjqWdm5bRK+Z7Qga8QM9kQYSXxdL5N+wk1hlXI=";
      version = "130.0.6723.58";
    };
    deps = {
      gn = {
        hash = "sha256-iNXRq3Mr8+wmY1SR4sV7yd2fDiIZ94eReelwFI0UhGU=";
        rev = "20806f79c6b4ba295274e3a589d85db41a02fdaa";
        url = "https://gn.googlesource.com/gn";
        version = "2024-09-09";
      };
    };
    hash = "sha256-w1xQr+B7ROeCqBRN+M9vmh45YTRqVfjDYSsN5saDuDo=";
    version = "130.0.6723.58";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-iNXRq3Mr8+wmY1SR4sV7yd2fDiIZ94eReelwFI0UhGU=";
        rev = "20806f79c6b4ba295274e3a589d85db41a02fdaa";
        url = "https://gn.googlesource.com/gn";
        version = "2024-09-09";
      };
      ungoogled-patches = {
        hash = "sha256-M+aJ1hhFV88lBBPl9xBYpYRut7yHa/HJYXoclckaZVM=";
        rev = "130.0.6723.58-1";
      };
    };
    hash = "sha256-w1xQr+B7ROeCqBRN+M9vmh45YTRqVfjDYSsN5saDuDo=";
    version = "130.0.6723.58";
  };
}
