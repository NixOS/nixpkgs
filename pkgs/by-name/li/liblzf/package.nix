{
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation {
  name = "liblzf";
  src = fetchzip {
    urls = [
      "http://dist.schmorp.de/liblzf/Attic/liblzf-3.6.tar.gz"
    ];
    hash = "sha256-m5MZfYAT9AtAXh2zk3lZasTfTGVbY8KWnyeftMaLanQ=";
  };
}
