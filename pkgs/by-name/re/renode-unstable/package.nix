{ renode
, fetchurl
, buildUnstable ? true
}:

(renode.override {
  inherit buildUnstable;
}).overrideAttrs (finalAttrs: _: {
  pname = "renode-unstable";
  version = "1.14.0+20231229gita76dac0ae";

  src = fetchurl {
    url = "https://builds.renode.io/renode-${finalAttrs.version}.linux-portable.tar.gz";
    hash = "sha256-fvwNN3sT8VZ7XJPrfpAbjSiuAB274QhuPeekwz0AU3c=";
  };
})
