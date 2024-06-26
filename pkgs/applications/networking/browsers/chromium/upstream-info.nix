{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-154JPXP5qCM94zQRkRSvPKk6RGIhani7FUwOXgIwUZ0=";
      hash_darwin_aarch64 =
        "sha256-HButB8+2DRiaazyBiT3643sBLaauRAZ1rvmEtt8Whac=";
      hash_linux = "sha256-6P9K6XTByonHaZYvOP+jTGizkmVdS8Ryn8UwV4BMGdQ=";
      version = "126.0.6478.126";
    };
    deps = {
      gn = {
        hash = "sha256-mNoQeHSSM+rhR0UHrpbyzLJC9vFqfxK1SD0X8GiRsqw=";
        rev = "df98b86690c83b81aedc909ded18857296406159";
        url = "https://gn.googlesource.com/gn";
        version = "2024-05-13";
      };
    };
    hash = "sha256-Z0QeUG4ykNqdlxXYgLteJQ0jS8apC5kwW5hwlUnhod0=";
    version = "126.0.6478.126";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-mNoQeHSSM+rhR0UHrpbyzLJC9vFqfxK1SD0X8GiRsqw=";
        rev = "df98b86690c83b81aedc909ded18857296406159";
        url = "https://gn.googlesource.com/gn";
        version = "2024-05-13";
      };
      ungoogled-patches = {
        hash = "sha256-lj/XYWkEo7M1i3D5e1MVXTXh02U55lNoo+sxKpu8FNc=";
        rev = "126.0.6478.114-1";
      };
    };
    hash = "sha256-sXP+/KXDoy3QnRoa9acGbsXKVCPspyNGtZTLMHBqxvw=";
    version = "126.0.6478.114";
  };
}
