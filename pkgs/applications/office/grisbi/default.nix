{ fetchurl, stdenv, gtk, pkgconfig, libgsf, libofx, intltool, wrapGAppsHook
, hicolor-icon-theme, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "grisbi-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/grisbi/${name}.tar.bz2";
    sha1 = "1159c5491967fa7afd251783013579ffb45b891b";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk libgsf libofx intltool hicolor-icon-theme libsoup
    gnome3.adwaita-icon-theme ];

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
