{ lib
, mkXfceDerivation
, glib
, gtk3
, thunar
, libxfce4util
, intltool
, gettext
, taglib
}:

mkXfceDerivation {
  category = "thunar-plugins";
  pname = "thunar-media-tags-plugin";
  version = "0.4.0";
  odd-unstable = false;

  sha256 = "sha256-2WA7EtDmNl8XP0wK00iyQcSqV3mnfHNJZTKhBJ/YWPQ=";

  nativeBuildInputs = [
    intltool
    gettext
  ];

  buildInputs = [
    thunar
    glib
    gtk3
    libxfce4util
    taglib
  ];

  meta = with lib; {
    description = "Thunar plugin providing tagging and renaming features for media files";
    maintainers = with maintainers; [ ncfavier ] ++ teams.xfce.members;
  };
}
