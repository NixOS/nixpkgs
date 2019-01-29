{ stdenv, fetchFromGitHub, fetchurl, pkgconfig, intltool, itstool, python3, wrapGAppsHook
, python3Packages, gst_all_1, gtk3
, gobject-introspection, librsvg, gnome3, libnotify, gsound
, meson, ninja
}:

let
  version = "0.999";

  # gst-transcoder will eventually be merged with gstreamer (according to
  # gst-transcoder 1.8.0 release notes). For now the only user is pitivi so we
  # don't bother exposing the package to all of nixpkgs.
  gst-transcoder = stdenv.mkDerivation rec {
    version = "1.14.1";
    name = "gst-transcoder-${version}";
    src = fetchFromGitHub {
      owner = "pitivi";
      repo = "gst-transcoder";
      rev = version;
      sha256 = "16skiz9akavssii529v9nr8zd54w43livc14khdyzv164djg9q8f";
    };
    nativeBuildInputs = [ pkgconfig meson ninja gobject-introspection python3 ];
    buildInputs = with gst_all_1; [ gstreamer gst-plugins-base ];
  };

in python3Packages.buildPythonApplication rec {
  name = "pitivi-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/pitivi/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0mxp2p4gg976fp1vj3rb5rmpl5mqfzncm9vw2719irl32f1qlvyb";
  };

  format = "other";

  patches = [
    # By default, the build picks up environment variables like PYTHONPATH
    # and saves them to the generated binary. This would make the build-time
    # dependencies part of the closure so we remove it.
    ./prevent-closure-contamination.patch
  ];

  postPatch = ''
    patchShebangs ./getenvvar.py
  '';

  nativeBuildInputs = [ meson ninja pkgconfig intltool itstool python3 wrapGAppsHook ];

  buildInputs = [
    gobject-introspection gtk3 librsvg gnome3.gnome-desktop gsound
    gnome3.defaultIconTheme
    gnome3.gsettings-desktop-schemas libnotify
    gst-transcoder
  ] ++ (with gst_all_1; [
    gstreamer gst-editing-services
    gst-plugins-base (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad gst-plugins-ugly gst-libav gst-validate
  ]);

  pythonPath = with python3Packages; [ pygobject3 gst-python pyxdg numpy pycairo matplotlib dbus-python ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "pitivi";
      versionPolicy = "none"; # we are using dev version, since the stable one is too old
    };
  };

  meta = with stdenv.lib; {
    description = "Non-Linear video editor utilizing the power of GStreamer";
    homepage = http://pitivi.org/;
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
