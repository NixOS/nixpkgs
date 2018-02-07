{ stdenv, fetchurl, libxml2, readline, zlib, perl, cairo, gtk3, gsl
, pkgconfig, gtksourceview, pango, gettext
}:

stdenv.mkDerivation rec {
  name = "pspp-1.0.1";

  src = fetchurl {
    url = "mirror://gnu/pspp/${name}.tar.gz";
    sha256 = "1r8smr5057993h90nx0mdnff8nxw9x546zzh6qpy4h3xblp1la5s";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 readline zlib perl cairo gtk3 gsl
    gtksourceview pango gettext ];

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
