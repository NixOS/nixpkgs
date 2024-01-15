{ renode
, fetchurl
, buildUnstable ? true
}:

(renode.override {
  inherit buildUnstable;
}).overrideAttrs (finalAttrs: _: {
  pname = "renode-unstable";
  version = "1.14.0+20240106git1b3952c2c";

  src = fetchurl {
    url = "https://builds.renode.io/renode-${finalAttrs.version}.linux-portable.tar.gz";
    hash = "sha256-tDo/01jYoq1Qg8h0BS4BQSPh3rsINpe72eMk9UBWgR0=";
  };
})
