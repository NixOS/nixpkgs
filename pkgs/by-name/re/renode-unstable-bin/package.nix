{
  fetchurl,
  renode-bin,
}:

renode-bin.overrideAttrs (
  finalAttrs: _: {
    pname = "renode-unstable";
    version = "1.17.0+20260923gite1227827a";

    src = fetchurl {
      url = "https://builds.renode.io/renode-${finalAttrs.version}.linux.tar.gz";
      hash = "sha256-a/iJjN14eZRy+1AKvWk0Fpxri1JJouKqMp4nad8VGkk=";
    };

    passthru.updateScript = ./update.sh;
  }
)
