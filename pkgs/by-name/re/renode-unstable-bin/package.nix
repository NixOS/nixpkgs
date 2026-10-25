{
  fetchurl,
  renode-bin,
}:

renode-bin.overrideAttrs (
  finalAttrs: _: {
    pname = "renode-unstable";
    version = "1.17.0+20261012git02eb136ad";

    src = fetchurl {
      url = "https://builds.renode.io/renode-${finalAttrs.version}.linux.tar.gz";
      hash = "sha256-6rcZKdb+CVnNV8ItIRKXx6hy2qdMz8tERbTU1I83QEk=";
    };

    passthru.updateScript = ./update.sh;
  }
)
