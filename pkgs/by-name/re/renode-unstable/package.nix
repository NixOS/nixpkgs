{ renode
, fetchurl
, buildUnstable ? true
}:

(renode.override {
  inherit buildUnstable;
}).overrideAttrs (finalAttrs: _: {
  pname = "renode-unstable";
  version = "1.14.0+20240315gita7bdc1e0e";

  src = fetchurl {
    url = "https://builds.renode.io/renode-${finalAttrs.version}.linux-portable.tar.gz";
    hash = "sha256-mSuu6Tg/O1kSanxKjRLzJv6iYcoytc8u53zU1g8e13A=";
  };
})
