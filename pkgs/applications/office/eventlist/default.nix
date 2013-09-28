{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "eventlist-0.6.95";

  src = fetchurl {
    url = "http://kde-look.org/CONTENT/content-files/107779-plasmoid-eventlist-0.6.95.tar.bz2";
    md5 = "67531c52806eee0a6cd911265f1eb9f5";
  };

  doCheck = true;

  meta = {
    description = "KDE Plasmoid to show events and todos on the desktop.";
    longDescription = ''
      This is a plasmoid to show the events and todos from Akonadi resources (KOrganizer, Birthdays etc.).
      With a google resource also Google calendar items can be shown.
      Also possible with a CalDAV resource.
      A facebook resource is also available.

      Incidences can be filtered, added, edited, deleted via context menu.
    '';
    homepage = http://kde-look.org/content/show.php/Eventlist?content=107779;
    license = "GPLv3+";

    platforms = stdenv.lib.platforms.all;
  };
}
