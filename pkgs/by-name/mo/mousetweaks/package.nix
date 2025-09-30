{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  gtk3,
  gnome,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "mousetweaks";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "005fhmvb45sa9mq17dpa23n1xnspiissx5rnpiy7hiqmy3g5rg8f";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    gsettings-desktop-schemas
    xorg.libX11
    xorg.libXtst
    xorg.libXfixes
    xorg.libXcursor
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
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
    homepage = "https://gitlab.gnome.org/Archive/mousetweaks";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.johnazoidberg ];
    mainProgram = "mousetweaks";
  };
}
