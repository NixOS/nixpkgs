{ lib
, fetchurl
, pkg-config
, gettext
, itstool
, python3
, wrapGAppsHook
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
, hicolor-icon-theme
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pitivi";
  version = "2023.03";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/pitivi/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "PX1OFEeavqMPvF613BKgxwErxqW2huw6mQxo8YpBS/M=";
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
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libpeas
    librsvg
    gsound
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

  pythonPath = with python3.pkgs; [
    pygobject3
    gst-python
    numpy
    pycairo
    matplotlib
    librosa
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # The icon theme is hardcoded.
      --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share"
    )
  '';

  postPatch = ''
    patchShebangs ./getenvvar.py
  '';

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
    maintainers = with maintainers; [ akechishiro ];
    platforms = platforms.linux;
  };
}
