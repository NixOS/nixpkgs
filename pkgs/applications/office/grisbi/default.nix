{ fetchurl, stdenv, gtk, pkgconfig, libgsf, libofx, intltool, wrapGAppsHook
, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  pname = "grisbi";
  version = "1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/grisbi/${pname}-${version}.tar.bz2";
    sha1 = "crv3bga72v6fw07wad0nkrgdg4war66j";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk libgsf libofx intltool libsoup
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
