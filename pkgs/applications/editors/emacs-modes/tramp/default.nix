{ stdenv, fetchurl, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "tramp-2.3.0";
  src = fetchurl {
    url = "mirror://gnu/tramp/${name}.tar.gz";
    sha256 = "1srwm24lwyf00w1661wbx03xg6j943dk05jhwnwdjf99m82cqbgi";
  };
  buildInputs = [ emacs texinfo ];
  meta = {
    description = "Transparently access remote files from Emacs. Newer versions than built-in.";
    homepage = https://www.gnu.org/software/tramp;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
