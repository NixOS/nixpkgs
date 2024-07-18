{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-YdQgrcTgyGtSfT6wBedSfBt40DaK3fG+uvB0yanvROU=";
      hash_darwin_aarch64 =
        "sha256-ht7LoA4ibEcWuXOk+JimCN0sjjPomHBcO8IZFNnMauk=";
      hash_linux = "sha256-VeCNeBKsKZ2bEM6Z9lJJaBVRjS1pW2gK2DMvmghfNEA=";
      version = "126.0.6478.182";
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
        hash = "sha256-DLxtXcm4gPVzBeGxjD4harmdQWoH8LKn6GBlhtq/MVM=";
        rev = "126.0.6478.126-1";
      };
    };
    hash = "sha256-Z0QeUG4ykNqdlxXYgLteJQ0jS8apC5kwW5hwlUnhod0=";
    version = "126.0.6478.126";
  };
}
