{ lib
, stdenv
, fetchurl
, gettext
, gnome
, libgtop
, gtk4
, libadwaita
, pcre2
, vte-gtk4
, appstream-glib
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook4
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "gnome-console";
  version = "43.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-console/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "t4TcSBVe86AkzYij9/650JO9mcZfKpcVo3+fu7Wq8VY=";
  };

  buildInputs = [
    gettext
    libgtop
    gtk4
    libadwaita
    pcre2
    vte-gtk4
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  passthru.tests.test = nixosTests.terminal-emulators.kgx;

  meta = with lib; {
    description = "Simple user-friendly terminal emulator for the GNOME desktop";
    homepage = "https://gitlab.gnome.org/GNOME/console";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ zhaofengli ]);
    platforms = platforms.unix;
  };
}
