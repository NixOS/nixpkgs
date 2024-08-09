{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-Evz39J4o3FJdJbYsFxmnLiZ9QiMeZttcbTtZ6wAVXoQ=";
      hash_darwin_aarch64 =
        "sha256-4Dkdi5C6dcuEewYvy60F5m4ynzb5lGWrJFs1Q+4vapI=";
      hash_linux = "sha256-Lls/gwyA28G8X41wXEIKlgNdmKWgWnPf6iHZGrU8e54=";
      version = "127.0.6533.99";
    };
    deps = {
      gn = {
        hash = "sha256-vzZu/Mo4/xATSD9KgKcRuBKVg9CoRZC9i0PEajYr4UM=";
        rev = "b3a0bff47dd81073bfe67a402971bad92e4f2423";
        url = "https://gn.googlesource.com/gn";
        version = "2024-06-06";
      };
    };
    hash = "sha256-VKPlcBfS6iw4E1nz0nYJLg273XmJ+RcGGktRbqQTTwQ=";
    version = "127.0.6533.99";
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
