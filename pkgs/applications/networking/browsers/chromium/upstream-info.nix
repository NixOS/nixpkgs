{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-4uE34f99fTiG5FJq0xnEodqQvNT2Aa8kesYOxY44xXA=";
      hash_darwin_aarch64 =
        "sha256-gDrfR5EgBx3YRxf3/08gayOhmEqSw4G/QcuNtfHmRHk=";
      hash_linux = "sha256-qMlM6ilsIqm8G5KLE4uGVb/s2bNyZSyQmxsq+EHKX/c=";
      version = "130.0.6723.91";
    };
    deps = {
      gn = {
        hash = "sha256-iNXRq3Mr8+wmY1SR4sV7yd2fDiIZ94eReelwFI0UhGU=";
        rev = "20806f79c6b4ba295274e3a589d85db41a02fdaa";
        url = "https://gn.googlesource.com/gn";
        version = "2024-09-09";
      };
    };
    hash = "sha256-qXCcHas3l3viszDtY5d5JEToPo2hHTaBmi+pJlKQr4M=";
    version = "130.0.6723.91";
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
        hash = "sha256-LhCrwOwPmEn5xlBLTgp2NMfQLxYbSg0pdZxshoqQAGw=";
        rev = "130.0.6723.91-1";
      };
    };
    hash = "sha256-qXCcHas3l3viszDtY5d5JEToPo2hHTaBmi+pJlKQr4M=";
    version = "130.0.6723.91";
  };
}
