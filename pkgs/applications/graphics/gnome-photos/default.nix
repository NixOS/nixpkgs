{ lib, stdenv
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
, gnome
, gobject-introspection
, grilo
, grilo-plugins
, gsettings-desktop-schemas
, gtk3
, itstool
, libdazzle
, libhandy
, libgdata
, libxml2
, meson
, ninja
, nixosTests
, pkg-config
, python3
, tracker
, tracker-miners
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-photos";
  version = "42.0";

  outputs = [ "out" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "JcsoFCUZnex7BF8T8y+PlgNMsMuLlNlvnf+vT1vmhVE=";
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
    pkg-config
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
    grilo
    grilo-plugins
    gsettings-desktop-schemas
    gtk3
    libdazzle
    libhandy
    libgdata
    tracker
    tracker-miners # For 'org.freedesktop.Tracker.Miner.Files' GSettings schema

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
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };

    tests = {
      installed-tests = nixosTests.installed-tests.gnome-photos;
    };
  };

  meta = with lib; {
    description = "Access, organize and share your photos";
    homepage = "https://wiki.gnome.org/Apps/Photos";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
