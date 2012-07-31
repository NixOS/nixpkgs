{stdenv, fetchurl} :

stdenv.mkDerivation rec {
  name = "joe-3.7";

  src = fetchurl {
    url = "mirror://sourceforge/joe-editor/${name}.tar.gz";
    sha256 = "0vqhffdjn3xwsfa383i6kdrpfwilq8b382ljjhy1v32smphmdr6a";
  };

  meta = {
    homepage = http://joe-editor.sourceforge.net;
  };
}
