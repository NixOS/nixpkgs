{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-c/lMkOdoW/tX57opl/weJGh/iyUeTTF5Xejs7IpA+Qg=";
      hash_darwin_aarch64 =
        "sha256-sst73OxUsrs2yWA72qdonARGi/W0FYObNfolidCiXio=";
      hash_linux = "sha256-p5cQmMdte7TfTPohg+rpIsyyYk1OKSNb0BwaMWmHuCo=";
      version = "127.0.6533.72";
    };
    deps = {
      gn = {
        hash = "sha256-vzZu/Mo4/xATSD9KgKcRuBKVg9CoRZC9i0PEajYr4UM=";
        rev = "b3a0bff47dd81073bfe67a402971bad92e4f2423";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-06";
      };
    };
    hash = "sha256-m99HaGCuIihDdbVnmu6xatnC/QDxgLVby2TWY/L+RHk=";
    version = "127.0.6533.72";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-vzZu/Mo4/xATSD9KgKcRuBKVg9CoRZC9i0PEajYr4UM=";
        rev = "b3a0bff47dd81073bfe67a402971bad92e4f2423";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-06";
      };
      ungoogled-patches = {
        hash = "sha256-IBdOV+eFJWD+kCxnhSWWjiBgMbP/DxF+gUVIIpWf4rc=";
        rev = "127.0.6533.72-1";
      };
    };
    hash = "sha256-m99HaGCuIihDdbVnmu6xatnC/QDxgLVby2TWY/L+RHk=";
    version = "127.0.6533.72";
  };
}
