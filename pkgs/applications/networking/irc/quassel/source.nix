{ fetchurl }:

rec {
  version = "0.12.3";
  src = fetchurl {
    url = "http://quassel-irc.org/pub/quassel-${version}.tar.bz2";
    sha256 = "0d6lwf6qblj1ia5j9mjy112zrmpbbg9mmxgscbgxiqychldyjgjd";
  };
}
