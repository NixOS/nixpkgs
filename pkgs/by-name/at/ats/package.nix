{ lib, stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  pname = "ats";
  version = "0.2.12";

  src = fetchurl {
    url = "mirror://sourceforge/ats-lang/ats-lang-anairiats-${version}.tgz";
    sha256 = "0l2kj1fzhxwsklwmn5yj2vp9rmw4jg0b18bzwqz72bfi8i39736k";
  };

  # this is necessary because atxt files usually include some .hats files
  patches = [ ./install-atsdoc-hats-files.patch ];
  buildInputs = [ gmp ];

  meta = {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = lib.licenses.gpl3Plus;
    # TODO: it looks like ATS requires gcc specifically. Someone with more knowledge
    # will need to experiment.
    platforms   = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
