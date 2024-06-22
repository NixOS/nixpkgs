{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-BWZaa1+3EUG11RmZjjbwG2UPZhlCpW3X9rkpiWrjgzM=";
      hash_darwin_aarch64 =
        "sha256-wkUIFolVdvcnEQKKehKCyD5GS5Q42fVFKj/iHtiIj8I=";
      hash_linux = "sha256-owTmkkgMcmuuhGv23uNjFjBdC49IJt+v6rjWu7xuchQ=";
      version = "126.0.6478.62";
    };
    deps = {
      gn = {
        hash = "sha256-mNoQeHSSM+rhR0UHrpbyzLJC9vFqfxK1SD0X8GiRsqw=";
        rev = "df98b86690c83b81aedc909ded18857296406159";
        url = "https://gn.googlesource.com/gn";
        version = "2024-05-13";
      };
    };
    hash = "sha256-sXP+/KXDoy3QnRoa9acGbsXKVCPspyNGtZTLMHBqxvw=";
    version = "126.0.6478.114";
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
