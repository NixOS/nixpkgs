{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-ugsxRhIPtDD7Y4/PsIc8Apqrtyo4uiVKoLmtRvQaJ3k=";
      hash_darwin_aarch64 =
        "sha256-aD/bHIxMm1OQu6un8cTYLPWoq/cC6kd1hTkxLEqGGRM=";
      hash_linux = "sha256-Ie5wtKXz27/vI97Ku7dqqQicR+tujgFUzANAIKTRw8M=";
      version = "118.0.5993.70";
    };
    deps = {
      gn = {
        hash = "sha256-SwlET5h5xtDlQvlt8wbG73ZfUWJr4hlWc+uQsBH5x9M=";
        rev = "cc56a0f98bb34accd5323316e0292575ff17a5d4";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-10";
      };
    };
    hash = "sha256-65rN17DIF+9FgZu7ohc9dM8ni6Qmqc9l1oyOcloip44=";
    hash_deb_amd64 = "sha256-RJcyIA0TdXWRk+K2GVcHSv4OSq5c6Y7InUblao3uusc=";
    version = "118.0.5993.117";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-SwlET5h5xtDlQvlt8wbG73ZfUWJr4hlWc+uQsBH5x9M=";
        rev = "cc56a0f98bb34accd5323316e0292575ff17a5d4";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-10";
      };
      ungoogled-patches = {
        hash = "sha256-10kSaLteFtvg3nGffslRpAxmc7nFsp0rA8gwm8jqt/8=";
        rev = "118.0.5993.117-1";
      };
    };
    hash = "sha256-65rN17DIF+9FgZu7ohc9dM8ni6Qmqc9l1oyOcloip44=";
    hash_deb_amd64 = "sha256-RJcyIA0TdXWRk+K2GVcHSv4OSq5c6Y7InUblao3uusc=";
    version = "118.0.5993.117";
  };
}
