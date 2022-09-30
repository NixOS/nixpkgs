{ lib
, stdenv
, cmake
, ninja
, intltool
, fetchurl
, libxml2
, webkitgtk
, highlight
, pkg-config
, gtk3
, glib
, libnotify
, libpst
, gspell
, evolution-data-server
, libgdata
, libgweather
, glib-networking
, gsettings-desktop-schemas
, wrapGAppsHook
, itstool
, shared-mime-info
, libical
, db
, gcr
, sqlite
, gnome
, gnome-desktop
, librsvg
, gdk-pixbuf
, libsecret
, nss
, nspr
, icu
, libcanberra-gtk3
, geocode-glib
, cmark
, bogofilter
, gst_all_1
, procps
, p11-kit
, openldap
, spamassassin
}:

stdenv.mkDerivation rec {
  pname = "evolution";
  version = "3.44.4";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "8LFuerrTx5RaKcMi8X2rSgjWHpm9fMkbjfNQU8XBLow=";
  };

  nativeBuildInputs = [
    cmake
    intltool
    itstool
    libxml2
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gnome.adwaita-icon-theme
    bogofilter
    db
    evolution-data-server
    gcr
    gdk-pixbuf
    glib
    glib-networking
    gnome-desktop
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk3
    gspell
    highlight
    icu
    libcanberra-gtk3
    geocode-glib
    cmark
    libgdata
    libgweather
    libical
    libnotify
    libpst
    librsvg
    libsecret
    nspr
    nss
    openldap
    p11-kit
    procps
    shared-mime-info
    sqlite
    webkitgtk
  ];

  propagatedUserEnvPkgs = [
    evolution-data-server
  ];

  cmakeFlags = [
    "-DENABLE_AUTOAR=OFF"
    "-DENABLE_LIBCRYPTUI=OFF"
    "-DENABLE_YTNEF=OFF"
    "-DWITH_SPAMASSASSIN=${spamassassin}/bin/spamassassin"
    "-DWITH_SA_LEARN=${spamassassin}/bin/sa-learn"
    "-DWITH_BOGOFILTER=${bogofilter}/bin/bogofilter"
    "-DWITH_OPENLDAP=${openldap}"
    "-DWITH_GWEATHER4=ON"
  ];

  requiredSystemFeatures = [
    "big-parallel"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "evolution";
      versionPolicy = "odd-unstable";
    };
  };

  PKG_CONFIG_LIBEDATASERVERUI_1_2_UIMODULEDIR = "${placeholder "out"}/lib/evolution-data-server/ui-modules";

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Evolution";
    description = "Personal information management application that provides integrated mail, calendaring and address book functionality";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
