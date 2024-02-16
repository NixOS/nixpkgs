{ renode
, fetchurl
, buildUnstable ? true
}:

(renode.override {
  inherit buildUnstable;
}).overrideAttrs (finalAttrs: _: {
  pname = "renode-unstable";
  version = "1.14.0+20240215git10667c665";

  src = fetchurl {
    url = "https://builds.renode.io/renode-${finalAttrs.version}.linux-portable.tar.gz";
    hash = "sha256-4u2mAW93ivXteVBimjbjDhYHzHHIQCdrINEFzapCd3c=";
  };
})
