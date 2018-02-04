{ stdenv, lib, pkgconfig, fetchurl, buildPythonApplication
, autoreconfHook, wrapGAppsHook
, intltool, yelp_tools, itstool, libxmlxx3
, python, pygobject3, gtk3, gnome3, substituteAll
, at_spi2_atk, at_spi2_core, pyatspi, dbus, dbus-python, pyxdg
, xkbcomp, gsettings_desktop_schemas, liblouis
, speechd, brltty, setproctitle, gst_all_1, gst-python
}:

with lib;
let
  version = "3.26.0";
  majorVersion = builtins.concatStringsSep "." (take 2 (splitString "." version));
in buildPythonApplication rec {
  name = "orca-${version}";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/orca/${majorVersion}/${name}.tar.xz";
    sha256 = "0xk5k9cbswymma60nrfj00dl97wypx59c107fb1hwi75gm0i07a7";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      xkbcomp = "${xkbcomp}/bin/xkbcomp";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook wrapGAppsHook pkgconfig libxmlxx3
    intltool yelp_tools itstool
  ];

  propagatedBuildInputs = [
    pygobject3 pyatspi dbus-python pyxdg brltty liblouis speechd gst-python setproctitle
  ];

  buildInputs = [
    python gtk3 at_spi2_atk at_spi2_core dbus gsettings_desktop_schemas
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
  ];

  # Run intltoolize to create po/Makefile.in.in
  preConfigure = ''
    intltoolize
  '';

  meta = {
    homepage = https://wiki.gnome.org/Projects/Orca;
    description = "Screen reader";
    longDescription = ''
      A free, open source, flexible and extensible screen reader that provides
      access to the graphical desktop via speech and refreshable braille.
      It works with applications and toolkits that support the Assistive
      Technology Service Provider Interface (AT-SPI). That includes the GNOME
      Gtk+ toolkit, the Java platform's Swing toolkit, LibreOffice, Gecko, and
      WebKitGtk. AT-SPI support for the KDE Qt toolkit is being pursued.

      Needs `services.gnome3.at-spi2-core.enable = true;` in `configuration.nix`.
    '';
    maintainers = with maintainers; [ berce ] ++ gnome3.maintainers;
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
