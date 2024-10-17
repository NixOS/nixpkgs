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
        hash = "sha256-8o3rDdojqVHMQCxI2T3MdJOXKlW3XX7lqpy3zWhJiaA=";
        rev = "d010e218ca7077928ad7c9e9cc02fe43b5a8a0ad";
        url = "https://gn.googlesource.com/gn";
        version = "2024-08-19";
      };
      ungoogled-patches = {
        hash = "sha256-kvpLE6SbXFur5xi1C8Ukvm4OoU5YB8PQCJdiakhFSAM=";
        rev = "129.0.6668.100-1";
      };
    };
    hash = "sha256-LOZ9EPw7VgBNEV7Wxb8H5WfSYTTWOL8EDP91uCrZAsA=";
    version = "129.0.6668.100";
  };
}
