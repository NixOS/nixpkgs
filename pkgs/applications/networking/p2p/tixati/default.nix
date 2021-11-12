{ lib, stdenv, fetchurl, glib, zlib, dbus, dbus-glib, gtk2, gdk-pixbuf, cairo, pango }:

stdenv.mkDerivation rec {
  pname = "tixati";
  version = "2.85";

  src = fetchurl {
    url = "https://download2.tixati.com/download/tixati-${version}-1.x86_64.manualinstall.tar.gz";
    sha256 = "sha256-grmJ52x2NcsgXw5BWrEGF9+7TYS/45HgHUXuZB+hVK4=";
  };

  installPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath ${lib.makeLibraryPath [ glib zlib dbus dbus-glib gtk2 gdk-pixbuf cairo pango ]} \
             tixati
    install -D tixati         $out/bin/tixati
    install -D tixati.desktop $out/share/applications/tixati.desktop
    install -D tixati.png     $out/share/icons/tixati.png
  '';

  dontStrip = true;

  meta = with lib; {
    description = "Torrent client";
    homepage = "http://www.tixati.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ volth ];
  };
}
