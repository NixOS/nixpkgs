# I haven't put much effort into this expressions .. so some optional depencencies may be missing - Marc
args: with args;
stdenv.mkDerivation rec {
  version = "1.6.4";
  name = "lyx-${version}";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/1.6.x/${name}.tar.bz2";
    sha256 = "1b56e53e6884a9f1417811c03e5c986d79955444e8169244a2b80b0709223d15";
  };

  buildInputs = [texLive qt python];

  meta = { 
      description = "WYSIWYM frontend for LaTeX, DocBook, etc.";
      homepage = "http://www.lyx.org";
      license = "GPL2";
  };
}
