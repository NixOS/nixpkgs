{ stdenv
, lib
, fetchurl
, fetchpatch
, atk
, cairo
, desktop-file-utils
, evolution-data-server-gtk4
, evolution
, gcr_4
, gettext
, glib
, gnome
, gpgme
, gtk3
, gtksourceview4
, gtkspell3
, libcryptui
, libxml2
, meson
, ninja
, pkg-config
, python3
, sqlite
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "almanah";
  version = "0.12.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "lMpDQOxlGljP66APR49aPbTZnfrGakbQ2ZcFvmiPMFo=";
  };

  patches = [
    # Fix build with meson 0.61
    # data/meson.build:2:5: ERROR: Function does not take positional arguments.
    # Patch taken from https://gitlab.gnome.org/GNOME/almanah/-/merge_requests/13
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/almanah/-/commit/8c42a67695621d1e30cec933a04e633e6030bbaf.patch";
      sha256 = "qyqFgYSu4emFDG/Mjwz1bZb3v3/4gwQSKmGCoPPNYCQ=";
    })

    # Port to Gcr 4
    # https://gitlab.gnome.org/GNOME/almanah/-/merge_requests/14
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/almanah/-/commit/cd44b476f4ffbf37c5d5f5b996ecd711db925576.patch";
      sha256 = "wJ1035NxgeTwUa0LoNcB6TSLxffoXBR3WbGAGkfggYY=";
    })

    # Port to GtkSourceView 4
    # https://gitlab.gnome.org/GNOME/almanah/-/merge_requests/15
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/almanah/-/commit/0ba7f05cba7feaf2ae2c220596aead5dfc676675.patch";
      sha256 = "5uvHTPzQloEq8SVt3EnZ+8mziBdXsDmu/e92/RtyFzE=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    cairo
    evolution-data-server-gtk4
    gcr_4
    glib
    evolution
    gpgme
    gtk3
    gtksourceview4
    gtkspell3
    libcryptui
    sqlite
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none"; # it is quite odd
    };
  };

  meta = with lib; {
    description = "Small GTK application to allow to keep a diary of your life";
    homepage = "https://wiki.gnome.org/Apps/Almanah_Diary";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
