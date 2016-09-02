{ stdenv, fetchurl, ed }:

stdenv.mkDerivation rec {
  name = "rcs-5.9.4";

  src = fetchurl {
    url = "mirror://gnu/rcs/${name}.tar.xz";
    sha256 = "1zsx7bb0rgvvvisiy4zlixf56ay8wbd9qqqcp1a1g0m1gl6mlg86";
  };

  buildInputs = [ ed ];

  doCheck = true;

  NIX_CFLAGS_COMPILE = [ "-std=c99" ];

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
    maintainers = with stdenv.lib.maintainers; [ eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
