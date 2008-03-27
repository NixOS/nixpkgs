# I haven't put much effort into this expressions .. so some optional depencencies may be missing - Marc
args: with args;
stdenv.mkDerivation {
  name = "lyx-1.5.4";

  src = fetchurl {
    url = http://lyx.cybermirror.org/stable/lyx-1.5.4.tar.bz2;
    sha256 = "6c8b9aafc287ee683b68ebb08166e660e27af9942a30291f14c18de39aca8f2b";
  };

  buildInputs = [texLive qt python];

  meta = { 
      description = "WYSIWYM frontend for LaTeX, DocBook, etc.";
      homepage = "http://www.lyx.org";
      license = "GPL2";
  };
}
