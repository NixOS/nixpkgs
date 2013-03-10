{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "rcs-5.8.1";

  src = fetchurl {
    url = "mirror://gnu/rcs/${name}.tar.gz";
    sha256 = "1b1y6s4gy3miv2bvx0z01kvnv58h35sw766lccdkxkalk43cml04";
  };

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

    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ eelco simons ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
