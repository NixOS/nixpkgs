{ stdenv, fetchurl, libextractor, gettext }:

stdenv.mkDerivation rec {
  name = "doodle-0.7.0";

  buildInputs = [ libextractor gettext ];

  src = fetchurl {
    url = "http://grothoff.org/christian/doodle/download/${name}.tar.gz";
    sha256 = "0ayx5q7chzll9sv3miq35xl36r629cvgdzphf379kxzlzhjldy3j";
  };

  meta = {
    homepage = http://grothoff.org/christian/doodle/;
    description = "Tool to quickly index and search documents on a computer";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
