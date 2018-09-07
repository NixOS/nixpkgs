{ stdenv, fetchurl, pkgconfig, intltool, itstool, python3, wrapGAppsHook
, python3Packages, gst, gtk3
, gobjectIntrospection, librsvg, gnome3, libnotify
, meson, ninja
}:

let
  version = "0.99";

  # gst-transcoder will eventually be merged with gstreamer (according to
  # gst-transcoder 1.8.0 release notes). For now the only user is pitivi so we
  # don't bother exposing the package to all of nixpkgs.
  gst-transcoder = stdenv.mkDerivation rec {
    version = "1.12.2";
    name = "gst-transcoder-${version}";
    src = fetchurl {
      name = "${name}.tar.gz";
      url = "https://github.com/pitivi/gst-transcoder/archive/${version}.tar.gz";
      sha256 = "0cnwmrsd321s02ff91m3j27ydj7f8wks0jvmp5admlhka6z7zxm9";
    };
    nativeBuildInputs = [ pkgconfig meson ninja gobjectIntrospection ];
    buildInputs = with gst; [ gstreamer gst-plugins-base ];
  };

in python3Packages.buildPythonApplication rec {
  name = "pitivi-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/pitivi/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0z4gvcr0cvyz2by47f36nqf7x2kfv9wn382w9glhs7l0d7b2zl69";
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
    gobjectIntrospection gtk3 librsvg gnome3.gnome-desktop gnome3.gsound
    gnome3.defaultIconTheme
    gnome3.gsettings-desktop-schemas libnotify
    gst-transcoder
  ] ++ (with gst; [
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
