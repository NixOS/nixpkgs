{ stdenv, fetchurl, kdelibs, kdepimlibs, akonadi, gettext }:

stdenv.mkDerivation rec {
  name = "eventlist-0.6.96";

  src = fetchurl {
    url = "http://kde-look.org/CONTENT/content-files/107779-plasmoid-eventlist-0.6.96.tar.bz2";
    sha256 = "26cc7bd1c465bf1379fd0ba1fa8592eaa62f2553734d1b283e17359103908eea";
  };

  doCheck = true;

  buildInputs = [ kdelibs kdepimlibs akonadi gettext ];

  meta = {
    inherit (kdelibs.meta) platforms;
    description = "KDE Plasmoid to show events and todos on the desktop.";
    longDescription = ''
      This is a plasmoid to show the events and todos from Akonadi resources (KOrganizer, Birthdays etc.).
      With a google resource also Google calendar items can be shown.
      Also possible with a CalDAV resource.
      A facebook resource is also available.

      Incidences can be filtered, added, edited, deleted via context menu.
    '';
    homepage = "http://kde-look.org/content/show.php/Eventlist?content=107779";
    license = "GPLv3+";

	  };
}
