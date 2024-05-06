{ lib
, pkg-config
, fetchurl
, meson
, ninja
, wrapGAppsHook3
, gobject-introspection
, gettext
, yelp-tools
, itstool
, python3
, gtk3
, gnome
, substituteAll
, at-spi2-atk
, at-spi2-core
, dbus
, xkbcomp
, procps
, lsof
, coreutils
, gsettings-desktop-schemas
, speechd-minimal
, brltty
, liblouis
, gst_all_1
}:

python3.pkgs.buildPythonApplication rec {
  pname = "orca";
  version = "47.2";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-XmevNX9xmOoApEOByrTE+U5oJtbtgAZo85QWziqrjlo=";
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
    meson
    ninja
    wrapGAppsHook3
    pkg-config
    gettext
    yelp-tools
    itstool
    gobject-introspection
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    dbus-python
    pyxdg
    brltty
    liblouis
    psutil
    speechd-minimal
    gst-python
    setproctitle
  ];

  strictDeps = false;

  buildInputs = [
    python3
    gtk3
    at-spi2-atk
    at-spi2-core
    dbus
    gsettings-desktop-schemas
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  dontWrapGApps = true; # Prevent double wrapping

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://orca.gnome.org/";
    changelog = "https://gitlab.gnome.org/GNOME/orca/-/blob/main/NEWS";
    description = "Screen reader";
    mainProgram = "orca";
    longDescription = ''
      A free, open source, flexible and extensible screen reader that provides
      access to the graphical desktop via speech and refreshable braille.
      It works with applications and toolkits that support the Assistive
      Technology Service Provider Interface (AT-SPI). That includes the GNOME
      GTK toolkit, the Java platform's Swing toolkit, LibreOffice, Gecko, and
      WebKitGtk. AT-SPI support for the KDE Qt toolkit is being pursued.

      Needs `services.gnome.at-spi2-core.enable = true;` in `configuration.nix`.
    '';
    maintainers = with maintainers; [ berce ] ++ teams.gnome.members;
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
