{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-BW83pgPJiKxdQ1K4+8KMDGBqvR+J3i+8AZmKfnYSmWk=";
      hash_darwin_aarch64 =
        "sha256-ZGZy4VDNRXJBMLtAhRUybssWRXSfEUWVRsF+etfhdzQ=";
      hash_linux = "sha256-1gM4KqzacJ13X5NmBn2hW6L/a7zN21rSZBk6a0IjCow=";
      version = "127.0.6533.88";
    };
    deps = {
      gn = {
        hash = "sha256-vzZu/Mo4/xATSD9KgKcRuBKVg9CoRZC9i0PEajYr4UM=";
        rev = "b3a0bff47dd81073bfe67a402971bad92e4f2423";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-06";
      };
    };
    hash = "sha256-nZZ2yrVu+0TloMaM455bmyeoeVnfeGR3EGubAf8snNU=";
    version = "127.0.6533.88";
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
        hash = "sha256-4LfYBqFQ/e/ePaOTSFBpELt0ilo/Vohwnwp8FvkfavU=";
        rev = "127.0.6533.88-1";
      };
    };
    hash = "sha256-nZZ2yrVu+0TloMaM455bmyeoeVnfeGR3EGubAf8snNU=";
    version = "127.0.6533.88";
  };
}
