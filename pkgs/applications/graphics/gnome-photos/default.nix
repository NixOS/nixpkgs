{ stdenv
, fetchurl
, at-spi2-core
, babl
, dbus
, desktop-file-utils
, dleyna-renderer
, gdk-pixbuf
, gegl
, geocode-glib
, gettext
, gexiv2
, gfbgraph
, glib
, gnome-online-accounts
, gnome3
, gobject-introspection
, grilo
, grilo-plugins
, gsettings-desktop-schemas
, gtk3
, itstool
, libdazzle
, libgdata
, libxml2
, meson
, ninja
, nixosTests
, pkgconfig
, python3
, tracker_2
, tracker-miners-2
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-photos";
  version = "3.38.0";

  outputs = [ "out" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1i64w69kk3sdf9vn7npnwrhy8qjwn0vizq200x3pgmbrfm3kjzv6";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection # for setup hook
    glib # for setup hook
    itstool
    libxml2
    meson
    ninja
    pkgconfig
    (python3.withPackages (pkgs: with pkgs; [
      dogtail
      pygobject3
      pyatspi
    ]))
    wrapGAppsHook
  ];

  buildInputs = [
    babl
    dbus
    dleyna-renderer
    gdk-pixbuf
    gegl
    geocode-glib
    gexiv2
    gfbgraph
    glib
    gnome-online-accounts
    gnome3.adwaita-icon-theme
    grilo
    grilo-plugins
    gsettings-desktop-schemas
    gtk3
    libdazzle
    libgdata
    tracker_2
    tracker-miners-2 # For 'org.freedesktop.Tracker.Miner.Files' GSettings schema

    at-spi2-core # for tests
  ];

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    patchShebangs tests/basic.py
  '';

  postFixup = ''
    wrapGApp "${placeholder "installedTests"}/libexec/installed-tests/gnome-photos/basic.py"

    # Upstream now uses a private tracker 2 instance.
    # https://gitlab.gnome.org/GNOME/gnome-photos/-/merge_requests/146
    # Let’s install them after fixup since they are already wrapped.
    ln -s ${tracker-miners-2}/libexec/tracker-extract ${tracker-miners-2}/libexec/tracker-miner-fs ${tracker_2}/libexec/tracker-store $out/libexec
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };

    tests = {
      installed-tests = nixosTests.installed-tests.gnome-photos;
    };
  };

  meta = with stdenv.lib; {
    description = "Access, organize and share your photos";
    homepage = "https://wiki.gnome.org/Apps/Photos";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
