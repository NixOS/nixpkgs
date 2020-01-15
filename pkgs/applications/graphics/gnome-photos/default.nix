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
, tracker
, tracker-miners
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-photos";
  version = "3.32.1";

  outputs = [ "out" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0nxa2jz1g73wypdsj19r4plf4hfkhs9mpl7gbhsiyqp1rkn84ahn";
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
    wrapProgram "${placeholder "installedTests"}/libexec/installed-tests/gnome-photos/basic.py" "''${gappsWrapperArgs[@]}"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };

    tests = {
      installed-tests = nixosTests.gnome-photos;
    };
  };

  meta = with stdenv.lib; {
    description = "Access, organize and share your photos";
    homepage = https://wiki.gnome.org/Apps/Photos;
    license = licenses.gpl3Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
