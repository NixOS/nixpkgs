{ stdenv, fetchurl, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "tramp-2.4.2";
  src = fetchurl {
    url = "mirror://gnu/tramp/${name}.tar.gz";
    sha256 = "082nwvi99y0bvpl1yhn4yjc8a613jh1pdck253lxn062lkcxxw61";
  };
  buildInputs = [ emacs texinfo ];
  meta = {
    description = "Transparently access remote files from Emacs. Newer versions than built-in.";
    homepage = "https://www.gnu.org/software/tramp";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
