{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  gettext,
  pkg-config,
  gnome,
  glib,
  gtk4,
  gobject-introspection,
  gdk-pixbuf,
  librest_1_0,
  libgweather,
  geoclue2,
  wrapGAppsHook4,
  desktop-file-utils,
  libportal,
  libshumate,
  libsecret,
  libsoup_3,
  gsettings-desktop-schemas,
  gjs,
  libadwaita,
  geocode-glib_2,
  tzdata,
  writeText,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-maps";
  version = "47.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-maps/${lib.versions.major finalAttrs.version}/gnome-maps-${finalAttrs.version}.tar.xz";
    hash = "sha256-TwLtLo44GeWdptm0rIgA6GY1349GpHzyqv2ThsgwEwM=";
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gobject-introspection
    # For post install script
    desktop-file-utils
    glib
    gtk4
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    geoclue2
    geocode-glib_2
    gjs
    gsettings-desktop-schemas
    gtk4
    libportal
    libshumate
    libgweather
    libadwaita
    librest_1_0
    libsecret
    libsoup_3
  ];

  mesonFlags = [
    "--cross-file=${writeText "crossfile.ini" ''
      [binaries]
      gjs = '${lib.getExe gjs}'
    ''}"
  ];

  preCheck = ''
    # “time.js” included by “timeTest” and “translationsTest” depends on “org.gnome.desktop.interface” schema.
    export XDG_DATA_DIRS="${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:$XDG_DATA_DIRS"
    export HOME=$(mktemp -d)
    export TZDIR=${tzdata}/share/zoneinfo

    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that we will delete before installation.
    mkdir -p $out/lib/gnome-maps
    ln -s $PWD/lib/libgnome-maps.so.0 $out/lib/gnome-maps/libgnome-maps.so.0
  '';

  postCheck = ''
    rm $out/lib/gnome-maps/libgnome-maps.so.0
  '';

  preFixup = ''
    substituteInPlace "$out/share/applications/org.gnome.Maps.desktop" \
      --replace-fail "Exec=gapplication launch org.gnome.Maps" \
                     "Exec=gnome-maps"
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-maps"; };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Maps/";
    description = "Map application for GNOME 3";
    mainProgram = "gnome-maps";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
})
