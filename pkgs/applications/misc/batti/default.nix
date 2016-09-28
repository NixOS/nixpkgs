{ stdenv, fetchurl
, pkgconfig, gettext, pythonPackages
, gtk, gdk_pixbuf, upower
, makeWrapper }:

let
  inherit (pythonPackages) dbus-python pygtk python;
in stdenv.mkDerivation rec {

  name = "batti-${version}";
  version = "0.3.8";

  src = fetchurl {
    url = "https://batti-gtk.googlecode.com/files/${name}.tar.gz";
    sha256 = "072d92gpsiiin631589nj77i2w1425p6db0qxyml7myscfy9jgx6";
  };

  buildInputs = with stdenv.lib;
  [ pkgconfig gettext python gtk pygtk dbus-python gdk_pixbuf upower makeWrapper ];

  configurePhase = "true";

  buildPhase = ''
    python setup.py build
  '';

  installPhase = ''
    python setup.py install --prefix $out
    wrapProgram "$out/bin/batti" \
      --set PYTHONPATH "$PYTHONPATH:$(toPythonPath $out)" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
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
    broken = true;  # see https://github.com/NixOS/nixpkgs/pull/4031#issuecomment-56283520 
  };
}

# TODO: fix the "icon not found" problems...
