{ stdenv, fetchurl, pkgconfig
, glib, gtk3, gnome3, gsettings-desktop-schemas, wrapGAppsHook
, libX11, libXtst, libXfixes, libXcursor
}:

stdenv.mkDerivation rec {
  pname = "mousetweaks";
  version = "3.32.0";

  src = fetchurl {
   url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
   sha256 = "005fhmvb45sa9mq17dpa23n1xnspiissx5rnpiy7hiqmy3g5rg8f";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [
    glib gtk3 gsettings-desktop-schemas
    libX11 libXtst libXfixes libXcursor
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Provides mouse accessibility enhancements for the GNOME desktop";
    longDescription = ''
      Mousetweaks provides mouse accessibility enhancements for the GNOME
      desktop. These enhancements are:

      - It offers a way to perform the various clicks without using any
      physical mouse buttons. (Hover Click)

      - It allows users to perform a secondary click by keeping the primary
      mouse button pressed for a predetermined amount of time. (Simulated
      Secondary Click)

      The features can be activated and configured through the Universal Access
      panel of the GNOME Control Center.
    '';
    homepage = "https://wiki.gnome.org/Projects/Mousetweaks";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.johnazoidberg ];
  };
}
