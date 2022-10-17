{ lib, stdenv, fetchurl, libxml2, readline, zlib, perl, cairo, gtk3, gsl
, pkg-config, gtksourceview, pango, gettext, dconf
, makeWrapper, gsettings-desktop-schemas, hicolor-icon-theme
, texinfo, ssw, python3
}:

stdenv.mkDerivation rec {
  pname = "pspp";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://gnu/pspp/${pname}-${version}.tar.gz";
    sha256 = "0lqrash677b09zxdlxp89z6k02y4i23mbqg83956dwl69wc53dan";
  };

  nativeBuildInputs = [ pkg-config texinfo python3 makeWrapper ];
  buildInputs = [ libxml2 readline zlib perl cairo gtk3 gsl
    gtksourceview pango gettext
    gsettings-desktop-schemas hicolor-icon-theme ssw
  ];

  doCheck = false;

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/psppire" \
     --prefix XDG_DATA_DIRS : "$out/share" \
     --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS" \
     --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
     --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules"
  '';

  meta = {
    homepage = "https://www.gnu.org/software/pspp/";
    description = "A free replacement for SPSS, a program for statistical analysis of sampled data";
    license = lib.licenses.gpl3Plus;

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

    platforms = lib.platforms.unix;
  };
}
