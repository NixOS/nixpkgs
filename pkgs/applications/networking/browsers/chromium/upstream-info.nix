{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-OvRkO/mBXOk3IqZtvjKzOsBPBaZzq+YOb//SsXtgB9k=";
      hash_darwin_aarch64 =
        "sha256-ODR4fFW24yh4vIGcWjBVH+mfK+LECU/LXlWVq+NBNlI=";
      hash_linux = "sha256-7vWid5i9bOyuGL2v9kdzv2yW2ZqWNNZDQScSDriaxxM=";
      version = "126.0.6478.61";
    };
    deps = {
      gn = {
        hash = "sha256-mNoQeHSSM+rhR0UHrpbyzLJC9vFqfxK1SD0X8GiRsqw=";
        rev = "df98b86690c83b81aedc909ded18857296406159";
        url = "https://gn.googlesource.com/gn";
        version = "2024-05-13";
      };
    };
    hash = "sha256-cB2jrasrtaFWM8tpG9leuC+jUAvoU8g5977cn4r7rbw=";
    version = "126.0.6478.61";
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
        hash = "sha256-2Yt91vWR5SYLBTO+PIEgFswkvwxJsNpKidOwxUBgLeg=";
        rev = "126.0.6478.55-1";
      };
    };
    hash = "sha256-nXRzISkU37TIgV8rjO0qgnhq8uM37M6IpMoGHdsOGIM=";
    version = "126.0.6478.55";
  };
}
