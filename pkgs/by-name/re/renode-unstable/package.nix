{ renode
, fetchurl
, buildUnstable ? true
}:

(renode.override {
  inherit buildUnstable;
}).overrideAttrs (finalAttrs: _: {
  pname = "renode-unstable";
  version = "1.14.0+20240119git1a0826937";

  src = fetchurl {
    url = "https://builds.renode.io/renode-${finalAttrs.version}.linux-portable.tar.gz";
    hash = "sha256-bv5+6DVzBFt5XeKcLJFpUHB5T1RKCNi/CuXXpIn6e9k=";
  };
})
