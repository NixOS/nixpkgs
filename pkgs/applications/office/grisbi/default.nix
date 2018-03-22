{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, hicolor-icon-theme, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "grisbi-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/grisbi/${name}.tar.bz2";
    sha256 = "1m31a1h4i59z36ri4a22rrd29byg6wnxq37559042hdhn557kazm";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk libofx intltool hicolor-icon-theme libsoup
    gnome3.defaultIconTheme ];

  meta = with stdenv.lib; {
    description = "A personnal accounting application.";
    longDescription = ''
      Grisbi is an application written by French developers, so it perfectly
      respects French accounting rules. Grisbi can manage multiple accounts,
      currencies and users. It manages third party, expenditure and receipt
      categories, budgetary lines, financial years, budget estimates, bankcard
      management and other information that make Grisbi adapted for
      associations.
    '';
    homepage = "http://grisbi.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ layus ];
    platforms = platforms.linux;
  };
}
