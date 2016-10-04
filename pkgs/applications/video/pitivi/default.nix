{ stdenv, fetchurl, pkgconfig, intltool, itstool, wrapGAppsHook
, python3Packages, gst, gtk3, hicolor_icon_theme
, gobjectIntrospection, librsvg, gnome3, libnotify
# for gst-transcoder:
, which, meson, ninja
}:

let
  version = "0.96";

  # gst-transcoder will eventually be merged with gstreamer (according to
  # gst-transcoder 1.8.0 release notes). For now the only user is pitivi so we
  # don't bother exposing the package to all of nixpkgs.
  gst-transcoder = stdenv.mkDerivation rec {
    name = "gst-transcoder-1.8.0";
    src = fetchurl {
      name = "${name}.tar.gz";
      url = "https://github.com/pitivi/gst-transcoder/archive/1.8.0.tar.gz";
      sha256 = "0iggr6idmp7cmfsf6pkhfl3jq1bkga37jl5prbcl1zapkzi26fg6";
    };
    buildInputs = [ which meson ninja pkgconfig gobjectIntrospection ]
      ++ (with gst; [ gstreamer gst-plugins-base ]);
  };

in stdenv.mkDerivation rec {
  name = "pitivi-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/pitivi/${version}/${name}.tar.xz";
    sha256 = "115d37mvi32yds8gqj2yidkk6pap7szavhjf2hw0388ynydlc2zs";
  };

  nativeBuildInputs = [ pkgconfig intltool itstool wrapGAppsHook ];

  buildInputs = [
    gobjectIntrospection gtk3 librsvg gnome3.gnome_desktop
    gnome3.defaultIconTheme
    gnome3.gsettings_desktop_schemas libnotify
    gst-transcoder
  ] ++ (with gst; [
    gstreamer gst-editing-services
    gst-plugins-base gst-plugins-good
    gst-plugins-bad gst-plugins-ugly gst-libav gst-validate
  ]) ++ (with python3Packages; [
    python pygobject3 gst-python pyxdg numpy pycairo sqlite3 matplotlib
    dbus-python
  ]);

  meta = with stdenv.lib; {
    description = "Non-Linear video editor utilizing the power of GStreamer";
    homepage    = "http://pitivi.org/";
    longDescription = ''
      Pitivi is a video editor built upon the GStreamer Editing Services.
      It aims to be an intuitive and flexible application
      that can appeal to newbies and professionals alike.
    '';
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
  };
}
