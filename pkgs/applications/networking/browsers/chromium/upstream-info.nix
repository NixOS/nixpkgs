{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-+Pcd++19/nJVsqGr2jzyjMTWYfb2U9wSgnNccDyGuGU=";
      hash_darwin_aarch64 =
        "sha256-vrbIpHrBwbzqars7D546eJ7zhEhAB0abq7MXiqlU4ts=";
      hash_linux = "sha256-NbZ1GULLWJ6L3kczz23HoUhGk6VgBOXcjZlL7t4Z6Ec=";
      version = "130.0.6723.116";
    };
    deps = {
      gn = {
        hash = "sha256-iNXRq3Mr8+wmY1SR4sV7yd2fDiIZ94eReelwFI0UhGU=";
        rev = "20806f79c6b4ba295274e3a589d85db41a02fdaa";
        url = "https://gn.googlesource.com/gn";
        version = "2024-09-09";
      };
    };
    hash = "sha256-eOCUKhFv205MD1gEY1FQQNCwxyELNjIAxUlPcRn74Lk=";
    version = "130.0.6723.116";
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
        hash = "sha256-+94tSSaOp6vzWkXN1qF3UXMm/Rs3pKmjf+U4x+af818=";
        rev = "130.0.6723.116-1";
      };
    };
    hash = "sha256-eOCUKhFv205MD1gEY1FQQNCwxyELNjIAxUlPcRn74Lk=";
    version = "130.0.6723.116";
  };
}
