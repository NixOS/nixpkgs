{ stdenv
, lib
, fetchurl
, fetchpatch2
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
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-photos";
  version = "43.0";

  outputs = [ "out" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "x6x0WNUz8p2VUBHHS3YiTXnqMbzBLp1tDOe2w3BNCOE=";
  };

  patches = [
    ./installed-tests-path.patch

    # Support babel 0.1.100
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/gnome-photos/-/commit/64c6f733a44bac5b7f08445a686c000681f93f5f.patch";
      hash = "sha256-iB5qCcDEH8pEX42ypEGJ9QMJWE8VXirv5JfdC1jP218=";
    })
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/gnome-photos/-/commit/9db32c3508a8c5d357a053d5f8278c34b4df18f3.patch";
      hash = "sha256-iz6gSu5rUBZ3Ki5GSRVuLcwX0LRQvJT17XmXQ7WJSmI=";
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
    homepage = "https://wiki.gnome.org/Apps/Photos";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
