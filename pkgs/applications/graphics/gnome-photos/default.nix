{ stdenv
, lib
, fetchurl
, at-spi2-core
, babl
, dbus
, desktop-file-utils
, dleyna-renderer
, gdk-pixbuf
, gegl
, geocode-glib_2
, gettext
, gexiv2
, glib
, gnome-online-accounts
, gnome
, gobject-introspection
, gsettings-desktop-schemas
, gtk3
, itstool
, libdazzle
, libportal-gtk3
, libhandy
, libxml2
, meson
, ninja
, nixosTests
, pkg-config
, python3
, tracker
, tracker-miners
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "gnome-photos";
  version = "44.0";

  outputs = [ "out" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "544hA5fTxigJxs1VIdpuzLShHd6lvyr4YypH9Npcgp4=";
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
    wrapGAppsHook3
  ];

  buildInputs = [
    babl
    dbus
    dleyna-renderer
    gdk-pixbuf
    gegl
    geocode-glib_2
    gexiv2
    glib
    gnome-online-accounts
    gsettings-desktop-schemas
    gtk3
    libdazzle
    libportal-gtk3
    libhandy
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
    mainProgram = "gnome-photos";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-photos";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
