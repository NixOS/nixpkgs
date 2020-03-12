{ stdenv
, pkgconfig
, fetchurl
, buildPythonApplication
, autoreconfHook
, wrapGAppsHook
, gobject-introspection
, gettext
, yelp-tools
, itstool
, libxmlxx3
, python
, pygobject3
, gtk3
, gnome3
, substituteAll
, at-spi2-atk
, at-spi2-core
, pyatspi
, dbus
, dbus-python
, pyxdg
, xkbcomp
, procps
, lsof
, coreutils
, gsettings-desktop-schemas
, speechd
, brltty
, liblouis
, setproctitle
, gst_all_1
, gst-python
}:

buildPythonApplication rec {
  pname = "orca";
  version = "3.34.2";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0aaagz8mxvfigrsdbmg22q44vf5yhkbw4rh4cnizysbfvijk4dan";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      cat = "${coreutils}/bin/cat";
      lsof = "${lsof}/bin/lsof";
      pgrep = "${procps}/bin/pgrep";
      xkbcomp = "${xkbcomp}/bin/xkbcomp";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook
    pkgconfig
    libxmlxx3
    gettext
    yelp-tools
    itstool
    gobject-introspection
  ];

  propagatedBuildInputs = [
    pygobject3
    pyatspi
    dbus-python
    pyxdg
    brltty
    liblouis
    speechd
    gst-python
    setproctitle
  ];

  strictDeps = false;

  buildInputs = [
    python
    gtk3
    at-spi2-atk
    at-spi2-core
    dbus
    gsettings-desktop-schemas
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Projects/Orca";
    description = "Screen reader";
    longDescription = ''
      A free, open source, flexible and extensible screen reader that provides
      access to the graphical desktop via speech and refreshable braille.
      It works with applications and toolkits that support the Assistive
      Technology Service Provider Interface (AT-SPI). That includes the GNOME
      GTK toolkit, the Java platform's Swing toolkit, LibreOffice, Gecko, and
      WebKitGtk. AT-SPI support for the KDE Qt toolkit is being pursued.

      Needs `services.gnome3.at-spi2-core.enable = true;` in `configuration.nix`.
    '';
    maintainers = with maintainers; [ berce ] ++ gnome3.maintainers;
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
