{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-a1gUAyNx0gKNZRKpQrsG3neKIy+xPquKUrzmcVbfQ54=";
      hash_darwin_aarch64 =
        "sha256-8OzxncQs/pXIo7dVLCgOlyO5jjTKRdTMoMaQsAiJeO8=";
      hash_linux = "sha256-lpYxCCjPacqZKiRMQrKdEaZJ8DO3jpbUK/6/j1i95a8=";
      version = "126.0.6478.55";
    };
    deps = {
      gn = {
        hash = "sha256-mNoQeHSSM+rhR0UHrpbyzLJC9vFqfxK1SD0X8GiRsqw=";
        rev = "df98b86690c83b81aedc909ded18857296406159";
        url = "https://gn.googlesource.com/gn";
        version = "2024-05-13";
      };
    };
    hash = "sha256-nXRzISkU37TIgV8rjO0qgnhq8uM37M6IpMoGHdsOGIM=";
    version = "126.0.6478.55";
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
