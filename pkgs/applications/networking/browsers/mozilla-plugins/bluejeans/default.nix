{ stdenv, fetchurl, xorg, gtk, glib, gdk_pixbuf, dpkg, libXext, libXfixes
, libXrender, libuuid, libXrandr, libXcomposite
}:

with stdenv.lib;

let

  rpathInstaller = makeLibraryPath
    [gtk glib stdenv.cc.cc];

  rpathPlugin = makeLibraryPath
    [ stdenv.cc.cc gtk glib xorg.libX11 gdk_pixbuf libXext libXfixes libXrender libXrandr libuuid libXcomposite ];

in

stdenv.mkDerivation rec {
  name = "bluejeans-2.100.41.8";

  version = "2.100.41.8";

  src = fetchurl {
    url = "https://swdl.bluejeans.com/skinny/bjnplugin_2.100.41.8-1_amd64.deb";
    sha256 = "013m17lpgi6nhw2df10wvrsnsjxy5n7z41ab69vj5m9h0prw9vd1";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  unpackPhase = "${dpkg}/bin/dpkg-deb -x $src .";

  installPhase =
    ''
      mkdir -p $out
      cp -R usr/lib $out/

      plugins=$out/lib/mozilla/plugins
      patchelf \
        --set-rpath "${rpathPlugin}" \
        $plugins/npbjnplugin_2.100.41.8.so

      patchelf \
        --set-rpath "${rpathInstaller}" \
        $plugins/npbjninstallplugin_2.100.41.8.so
    '';

  dontStrip = true;
  dontPatchELF = true;

  passthru.mozillaPlugin = "/lib/mozilla/plugins";

  meta = {
    homepage = http://bluejeans.com;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
