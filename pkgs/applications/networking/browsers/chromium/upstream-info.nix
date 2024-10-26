{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-SZfl93TcaD9j59zGflPFmHgIP5NaS8bgDi3l3SRRFiI=";
      hash_darwin_aarch64 =
        "sha256-wLX63aA8l+23ehdBHPcXtoZ2WEhrmYVKzqUDBbrhSRw=";
      hash_linux = "sha256-kP6N7fM+7+S3JwT2JvqfWDRCfAQiNc/rQlHxjJ8DNuo=";
      version = "130.0.6723.69";
    };
    deps = {
      gn = {
        hash = "sha256-iNXRq3Mr8+wmY1SR4sV7yd2fDiIZ94eReelwFI0UhGU=";
        rev = "20806f79c6b4ba295274e3a589d85db41a02fdaa";
        url = "https://gn.googlesource.com/gn";
        version = "2024-09-09";
      };
    };
    hash = "sha256-k0epbUw9D3Vx7ELNDXIFEnsML+cYvDnHZFOW0kz4Kq8=";
    version = "130.0.6723.69";
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
        hash = "sha256-usNlX/ol8Zn3lQTvp311DuyYbSHF/HN0r7k8qeUIJmU=";
        rev = "130.0.6723.69-1";
      };
    };
    hash = "sha256-k0epbUw9D3Vx7ELNDXIFEnsML+cYvDnHZFOW0kz4Kq8=";
    version = "130.0.6723.69";
  };
}
