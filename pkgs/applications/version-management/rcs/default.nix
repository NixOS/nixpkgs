{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "rcs-5.8";

  src = fetchurl {
    url = "mirror://gnu/rcs/${name}.tar.gz";
    sha256 = "0q12nlghv4khxw5lk0y4949caghzg4jg0ripddi2h3q75vmfh6vh";
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
