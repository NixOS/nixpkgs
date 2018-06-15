{ stdenv, fetchurl, gettext, gtk3, pythonPackages
, gdk_pixbuf, libnotify, gst_all_1
, libgnome-keyring3, networkmanager
, wrapGAppsHook, gnome3
# otherwise passwords are stored unencrypted
, withGnomeKeyring ? true
}:

let
  inherit (pythonPackages) python;
in pythonPackages.buildPythonApplication rec {
  name = "mailnag-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "https://github.com/pulb/mailnag/archive/v${version}.tar.gz";
    sha256 = "ec7ac027d93bc7d88fc270858f5a181453a6ff07f43cab20563d185818801fee";
  };

  buildInputs = [
    gettext gtk3 gdk_pixbuf libnotify gst_all_1.gstreamer
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gnome3.defaultIconTheme
  ] ++ stdenv.lib.optional withGnomeKeyring libgnome-keyring3;

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  propagatedBuildInputs = with pythonPackages; [
    pygobject3 dbus-python pyxdg
  ];

  buildPhase = "";

  installPhase = "${python}/bin/python setup.py install --prefix=$out";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "An extensible mail notification daemon";
    homepage = https://github.com/pulb/mailnag;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
