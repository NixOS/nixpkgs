{stdenv, fetchurl, fetchurlGnome, gtk, pkgconfig, perl, perlXMLParser, libxml2, gettext
, python, libxml2Python, docbook5, docbook_xsl, libxslt, intltool, libart_lgpl
, withGNOME ? false, libgnomeui }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurlGnome {
    project = "dia";
    major = "0"; minor = "97"; patchlevel = "2"; extension = "xz";
    sha256 = "1qgawm7rrf4wd1yc0fp39ywv8gbz4ry1s16k00dzg5w6p67lfqd7";
  };

  correctPersistence = fetchurl {
    url = https://launchpadlibrarian.net/132677658/persistence;
    sha256 = "1rv6zv9i03bna4bdp1wzn72lg7kdwi900y1izdq0imibi54nxjsk";
  };

  buildInputs =
    [ gtk perlXMLParser libxml2 gettext python libxml2Python docbook5
      libxslt docbook_xsl libart_lgpl
    ] ++ stdenv.lib.optional withGNOME libgnomeui;

  nativeBuildInputs = [ pkgconfig intltool perl ];

  configureFlags = stdenv.lib.optionalString withGNOME "--enable-gnome";

  patches = [ ./glib-top-level-header.patch ];

  # This file should normally require a gtk-update-icon-cache -q /usr/share/icons/hicolor command
  # It have no reasons to exist in a redistribuable package
  postInstall = ''
    rm $out/share/icons/hicolor/icon-theme.cache

    cd "$out"/bin/
    mv dia .dia-wrapped
    echo '#! ${stdenv.shell}' >> dia
    echo 'test -f "$HOME/.dia/persistence" || cp ${correctPersistence} "$HOME/.dia/persistence" ' >> dia
    echo 'chmod u+rw "$HOME/.dia/persistence" ' >> dia
    echo "\"$out/bin/"'.dia-wrapped" "$@"' >> dia
    chmod a+x dia
  '';

  meta = {
    description = "Gnome Diagram drawing software";
    homepage = http://live.gnome.org/Dia;
    maintainers = with stdenv.lib.maintainers; [raskin urkud];
    platforms = stdenv.lib.platforms.linux;
  };
}
