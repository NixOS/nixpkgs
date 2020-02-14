{ stdenv, fetchurl, libxml2, readline, zlib, perl, cairo, gtk3, gsl
, pkgconfig, gtksourceview, pango, gettext, dconf
, makeWrapper, gsettings-desktop-schemas, hicolor-icon-theme
, texinfo, ssw
}:

stdenv.mkDerivation rec {
  pname = "pspp";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://gnu/pspp/${pname}-${version}.tar.gz";
    sha256 = "07pp27zycrb5x927jwaj9r3q7hy915jh51xs85zxby6gfiwl63m5";
  };

  nativeBuildInputs = [ pkgconfig texinfo ];
  buildInputs = [ libxml2 readline zlib perl cairo gtk3 gsl
    gtksourceview pango gettext
    makeWrapper gsettings-desktop-schemas hicolor-icon-theme ssw
  ];

  doCheck = false;

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/psppire" \
     --prefix XDG_DATA_DIRS : "$out/share" \
     --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS" \
     --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
     --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules"
  '';

  meta = {
    homepage = https://www.gnu.org/software/pspp/;
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

    platforms = stdenv.lib.platforms.unix;
  };
}
