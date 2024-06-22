{ stdenv
, lib
, fetchurl
, fetchpatch
, autoreconfHook
, gtk-doc
, vala
, gobject-introspection
, wrapGAppsHook3
, gsettings-desktop-schemas
, gspell
, libgedit-gtksourceview
, libgedit-tepl
, libgee
, gnome
, glib
, pkg-config
, gettext
, itstool
, libxml2
}:

stdenv.mkDerivation rec {
  version = "3.46.0";
  pname = "gnome-latex";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1nVVY5sqFaiuvVTzNTVORP40MxQ648s8ynqOJvgRKto=";
  };

  patches = [
    # Adapt for Tepl -> libgedit-tepl rename
    (fetchpatch {
      url = "https://gitlab.gnome.org/swilmet/gnome-latex/-/commit/41e532c427f43a5eed9081766963d6e29a9975a1.patch";
      hash = "sha256-gu8o/er4mP92dE5gWg9lGx5JwTHB8ytk3EMNlwlIpq4=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gtk-doc
    vala
    gobject-introspection
    wrapGAppsHook3
    itstool
    gettext
  ];

  buildInputs = [
    gnome.adwaita-icon-theme
    glib
    gsettings-desktop-schemas
    gspell
    libgedit-gtksourceview
    libgedit-tepl
    libgee
    libxml2
  ];

  configureFlags = [
    "--disable-dconf-migration"
  ];

  doCheck = true;

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  passthru.updateScript = gnome.updateScript {
    packageName = pname;
    versionPolicy = "odd-unstable";
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/swilmet/gnome-latex";
    description = "LaTeX editor for the GNOME desktop";
    maintainers = with maintainers; [ manveru bobby285271 ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "gnome-latex";
  };
}
