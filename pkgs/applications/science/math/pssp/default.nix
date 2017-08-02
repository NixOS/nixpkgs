{ stdenv, fetchurl, libxml2, readline, zlib, perl, cairo, gtk2, gsl
, pkgconfig, gtksourceview, pango, gettext, libglade
}:

stdenv.mkDerivation rec {
  name = "pspp-0.8.3";

  src = fetchurl {
    url = "mirror://gnu/pspp/${name}.tar.gz";
    sha256 = "0vri2pzvmm38qaihfvwlry30f40lcnps4blg59ixic4q20ldxf5d";
  };

  buildInputs = [ libxml2 readline zlib perl cairo gtk2 gsl pkgconfig
    gtksourceview pango gettext libglade ];

  doCheck = false;

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.gnu.org/software/pspp/;
    description = "A free replacement for SPSS, a program for statistical analysis of sampled data";
    license = stdenv.lib.licenses.gpl3Plus;

    longDescription = ''
      PSPP is a program for statistical analysis of sampled data. It is
      a Free replacement for the proprietary program SPSS.

      PSPP can perform descriptive statistics, T-tests, anova, linear
      and logistic regression, cluster analysis, factor analysis,
      non-parametric tests and more. Its backend is designed to perform
      its analyses as fast as possible, regardless of the size of the
      input data. You can use PSPP with its graphical interface or the
      more traditional syntax commands.
    '';

    platforms = stdenv.lib.platforms.linux;
  };
}
