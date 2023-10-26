{
  beta = {
    deps = {
      gn = {
        rev = "811d332bd90551342c5cbd39e133aa276022d7f8";
        hash = "sha256-WCq+PNkWxWpssUOQyQbAZ5l6k+hg+qGMsoaMG0Ybj0o=";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-01";
      };
    };
    hash = "sha256-spzY2u5Wk52BrKCk9aQOEp/gbppaGVLCQxXa+3JuajA=";
    hash_deb_amd64 = "sha256-eTeEeNa4JuCW81+SUAyrKi3S0/TJNTAoTktWQ0JsgYc=";
    version = "117.0.5938.22";
  };
  dev = {
    deps = {
      gn = {
        rev = "cc56a0f98bb34accd5323316e0292575ff17a5d4";
        hash = "sha256-SwlET5h5xtDlQvlt8wbG73ZfUWJr4hlWc+uQsBH5x9M=";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-10";
      };
    };
    hash = "sha256-W0fZuvv9jz03ibQqB6MG45aw2zPklfxoFzZzr+kRuJk=";
    hash_deb_amd64 = "sha256-XWxRFLFxBqnvKcoB5HErwVbtHCGYRteLeTv44zVMwIc=";
    version = "118.0.5966.0";
  };
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
        rev = "cc56a0f98bb34accd5323316e0292575ff17a5d4";
        hash = "sha256-SwlET5h5xtDlQvlt8wbG73ZfUWJr4hlWc+uQsBH5x9M=";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-10";
      };
    };
    hash = "sha256-CTkw92TiRD2tkYu5a5dy8fjpR2MMOMCvcbxXhJ36Bp8=";
    hash_deb_amd64 = "sha256-Y4IUVJIBlt2kcrK5c8SiUyvetC3aBhQQIBTCSaDUKxs=";
    version = "118.0.5993.88";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        rev = "cc56a0f98bb34accd5323316e0292575ff17a5d4";
        hash = "sha256-SwlET5h5xtDlQvlt8wbG73ZfUWJr4hlWc+uQsBH5x9M=";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-10";
      };
      ungoogled-patches = {
        rev = "118.0.5993.88-1";
        hash = "sha256-Tv/DSvVHa/xU5SXNtobaJPOSrbMMwYIu0+okSkw7RJ4=";
      };
    };
    hash = "sha256-CTkw92TiRD2tkYu5a5dy8fjpR2MMOMCvcbxXhJ36Bp8=";
    hash_deb_amd64 = "sha256-Y4IUVJIBlt2kcrK5c8SiUyvetC3aBhQQIBTCSaDUKxs=";
    version = "118.0.5993.88";
  };
}
