args: with args;
stdenv.mkDerivation {
  name = "maxima-5.17.0";

  src = fetchurl {
    url = "mirror://sourceforge/maxima/maxima-5.17.0.tar.gz";
    sha256 = "1nzphlm4al0j8jcgalscdqfcgkbscl68qz2mkm8n8804mss32alj";
  };

  buildInputs =[clisp];

  meta = {
    description = "Maxima computer algebra system";
    homepage = http://maxima.sourceforge.net;
  };
}
