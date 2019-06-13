{ stdenv, fetchurl, gettext, gtk3, pythonPackages
, gdk_pixbuf, libnotify, gst_all_1
, libgnome-keyring3
, wrapGAppsHook, gnome3
# otherwise passwords are stored unencrypted
, withGnomeKeyring ? true
}:

let
  inherit (pythonPackages) python;
in pythonPackages.buildPythonApplication rec {
  name = "mailnag-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/pulb/mailnag/archive/v${version}.tar.gz";
    sha256 = "0cp5pad6jzd5c14pddbi9ap5bi78wjhk1x2p0gbblmvmcasw309s";
  };

  buildInputs = [
    gtk3 gdk_pixbuf libnotify gst_all_1.gstreamer
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gnome3.adwaita-icon-theme
  ] ++ stdenv.lib.optional withGnomeKeyring libgnome-keyring3;

  nativeBuildInputs = [
    gettext
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
    maintainers = with maintainers; [ ];
  };
}
