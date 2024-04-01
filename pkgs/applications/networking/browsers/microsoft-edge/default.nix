{
  beta = import ./browser.nix {
    channel = "beta";
    version = "123.0.2420.53";
    revision = "1";
    hash = "sha256-6mE/zxVvGYrI7Emk5RBW+GC5W1FbVPFUeKMjev1yeFQ=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "124.0.2464.2";
    revision = "1";
    hash = "sha256-vNvSzoVSVewTbKrnE6f+0Hx/1N5gOvRcdRGsmunBJHA=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "123.0.2420.53";
    revision = "1";
    hash = "sha256-7C6wZCIRodqWKimbnUl32TOhizsiE3U/be3tlpSNtt0=";
  };
}
