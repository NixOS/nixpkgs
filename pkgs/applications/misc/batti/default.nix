{ stdenv, fetchurl
, pkgconfig, makeWrapper, gettext, python
, gtk, pygtk, dbus_python
, upower }:

stdenv.mkDerivation rec {

  name = "batti-${version}";
  version = "0.3.8";

  src = fetchurl {
    url = "https://batti-gtk.googlecode.com/files/${name}.tar.gz";
    sha256 = "072d92gpsiiin631589nj77i2w1425p6db0qxyml7myscfy9jgx6";
  };

  buildInputs = with stdenv.lib;
  [ pkgconfig makeWrapper gettext python gtk pygtk dbus_python upower ];

  configurePhase = "true";

  buildPhase = ''
    python setup.py build
  '';

  installPhase = ''
    python setup.py install --prefix $out
    wrapProgram $out/bin/batti --set PYTHONPATH "$PYTHONPATH:$(toPythonPath $out)"
  '';


  meta = with stdenv.lib; {
    description = "An {UPower,GTK}-based battery monitor for the system tray";
    longDescription = ''
      Batti is a simple battery monitor for the system tray. Batti
      uses UPower, and if that is missing DeviceKit.Power, for it's
      power information.
    '';
    homepage = http://batti-gtk.googlecode.com/;
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

# TODO: fix the "icon not found" problems...
