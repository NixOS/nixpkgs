{
  fetchurl,
  renode-bin,
}:

renode-bin.overrideAttrs (
  finalAttrs: _: {
    pname = "renode-unstable";
    version = "1.17.0+20261026git04cafbb29";
    # Point meta.position here instead of renode-bin/package.nix so
    # nixpkgs-update edits the right file.
    pos = __curPos;

    src = fetchurl {
      url = "https://builds.renode.io/renode-${finalAttrs.version}.linux.tar.gz";
      hash = "sha256-phgMaYgn/MIcxS3cH5L47NsLmb/vWoSBKo6D/U3pdXA=";
    };

    passthru.updateScript = ./update.sh;
  }
)
