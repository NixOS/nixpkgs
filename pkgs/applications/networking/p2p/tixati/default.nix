{ stdenv, fetchurl, glib, zlib, dbus, dbus-glib, gtk2, gdk_pixbuf, cairo, pango }:

stdenv.mkDerivation rec {
  name = "tixati-${version}";
  version = "2.61";

  src = fetchurl {
    url = "https://download2.tixati.com/download/tixati-${version}-1.x86_64.manualinstall.tar.gz";
    sha256 = "05f8lcsac2mr90bhk999qkj8wwd6igdl07389bqrd1ydjasacl2k";
  };

  installPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath ${stdenv.lib.makeLibraryPath [ glib zlib dbus dbus-glib gtk2 gdk_pixbuf cairo pango ]} \
             tixati
    install -D tixati         $out/bin/tixati
    install -D tixati.desktop $out/share/applications/tixati.desktop
    install -D tixati.png     $out/share/icons/tixati.png
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Torrent client";
    homepage = http://www.tixati.com;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ volth ];
  };
}
