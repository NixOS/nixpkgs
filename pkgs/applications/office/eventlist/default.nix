{ stdenv, fetchurl, kdelibs, kdepimlibs, akonadi }:

stdenv.mkDerivation rec {
  name = "eventlist-0.6.95";

  src = fetchurl {
    url = "http://kde-look.org/CONTENT/content-files/107779-plasmoid-eventlist-0.6.95.tar.bz2";
    sha256 = "29d3ff0b84353c2e563e05f75cd729b9e2971365eed9b8ce9b38d94f51901b94";
  };

  doCheck = true;

  buildInputs = [ kdelibs ];

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
