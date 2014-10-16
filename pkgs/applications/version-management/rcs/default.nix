{ stdenv, fetchurl, ed }:

stdenv.mkDerivation rec {
  name = "rcs-5.9.3";

  src = fetchurl {
    url = "mirror://gnu/rcs/${name}.tar.xz";
    sha256 = "0isvzwfvqkg7zcsznra6wqh650z49ib113n7gp6ncxv5p30x3c38";
  };

  buildInputs = [ ed ];

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/rcs/;
    description = "Revision control system";
    longDescription =
      '' The GNU Revision Control System (RCS) manages multiple revisions of
         files. RCS automates the storing, retrieval, logging,
         identification, and merging of revisions.  RCS is useful for text
         that is revised frequently, including source code, programs,
         documentation, graphics, papers, and form letters.
      '';

    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ eelco simons ];
    platforms = stdenv.lib.platforms.all;
  };
}
