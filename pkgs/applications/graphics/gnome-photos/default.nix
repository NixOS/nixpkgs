{ stdenv
, fetchurl
, fetchpatch
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
, tracker
, tracker-miners
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

    # Port to Tracker 3
    # https://gitlab.gnome.org/GNOME/gnome-photos/-/merge_requests/135
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-photos/commit/f39a85bb1a82093f4ba615494ff7e95609674fc2.patch";
      sha256 = "M5r5WuB1JpUBVN3KxNvpMiPWj0pIpT+ImQMOiGtUgT4=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-photos/commit/3d847ff80d429cadf0bc59aa50caa37bf27c0201.patch";
      sha256 = "zGjSL1qpWVJ/5Ifgh2CbhFSBR/WDAra8F+YUOemyxyU=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-photos/commit/2eb923726147b05c936dee64b205d833525db1df.patch";
      sha256 = "vCA6NXHzmNf2GoLqzWwIyziC6puJgJ0QTLeKWsAEFAE=";
    })
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
