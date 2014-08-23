{ stdenv, fetchurl, ed }:

stdenv.mkDerivation rec {
  name = "rcs-5.9.2";

  src = fetchurl {
    url = "mirror://gnu/rcs/${name}.tar.xz";
    sha256 = "0wdmmplga9k05d9k7wjqv4zb6xvvzsli8hmn206pvangki1g66k5";
  };

  buildInputs = [ ed ];

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/rcs/;
    description = "GNU RCS, a revision control system";
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
