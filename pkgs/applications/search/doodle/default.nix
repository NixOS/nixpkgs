{ stdenv, fetchurl, libextractor, gettext }:

stdenv.mkDerivation rec {
  name = "doodle-0.7.1";

  buildInputs = [ libextractor gettext ];

  src = fetchurl {
    url = "https://grothoff.org/christian/doodle/download/${name}.tar.gz";
    sha256 = "086va4q8swiablv5x72yikrdh5swhy7kzmg5wlszi5a7vjya29xw";
  };

  meta = {
    homepage = https://grothoff.org/christian/doodle/;
    description = "Tool to quickly index and search documents on a computer";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
