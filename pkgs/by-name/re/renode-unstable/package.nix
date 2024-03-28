{ renode
, fetchurl
, buildUnstable ? true
}:

(renode.override {
  inherit buildUnstable;
}).overrideAttrs (finalAttrs: _: {
  pname = "renode-unstable";
  version = "1.15.0+20240323git3bd8e280d";

  src = fetchurl {
    url = "https://builds.renode.io/renode-${finalAttrs.version}.linux-portable.tar.gz";
    hash = "sha256-hIPBM9PE6vtqo8XJvOWS3mIa9Vr7v9bcMdXmeQzBYsk=";
  };
})
