{ lib
, fetchurl
, pkg-config
, gettext
, itstool
, python3
, wrapGAppsHook
, python3Packages
, gst_all_1
, gtk3
, gobject-introspection
, libpeas
, librsvg
, gnome
, libnotify
, gsound
, meson
, ninja
, gsettings-desktop-schemas
}:

python3Packages.buildPythonApplication rec {
  pname = "pitivi";
  version = "2021.05";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/pitivi/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "z1aTxGxCqw2hSi5Zv89LyIBgS0HpzTqo0uvcYIJ7dcc=";
  };

  patches = [
    # By default, the build picks up environment variables like PYTHONPATH
    # and saves them to the generated binary. This would make the build-time
    # dependencies part of the closure so we remove it.
    ./prevent-closure-contamination.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    gtk3
    libpeas
    librsvg
    gnome.gnome-desktop
    gsound
    gnome.adwaita-icon-theme
    gsettings-desktop-schemas
    libnotify
  ] ++ (with gst_all_1; [
    gstreamer
    gst-editing-services
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
    gst-devtools
  ]);

  pythonPath = with python3Packages; [
    pygobject3
    gst-python
    pyxdg
    numpy
    pycairo
    matplotlib
    dbus-python
  ];

  postPatch = ''
    patchShebangs ./getenvvar.py
  '';

  # Fixes error
  #     Couldn’t recognize the image file format for file ".../share/pitivi/pixmaps/asset-proxied.svg"
  # at startup, see https://github.com/NixOS/nixpkgs/issues/56943
  # and https://github.com/NixOS/nixpkgs/issues/89691#issuecomment-714398705.
  strictDeps = false;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "pitivi";
      versionPolicy = "none"; # we are using dev version, since the stable one is too old
    };
  };

  meta = with lib; {
    description = "Non-Linear video editor utilizing the power of GStreamer";
    homepage = "http://pitivi.org/";
    longDescription = ''
      Pitivi is a video editor built upon the GStreamer Editing Services.
      It aims to be an intuitive and flexible application
      that can appeal to newbies and professionals alike.
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
