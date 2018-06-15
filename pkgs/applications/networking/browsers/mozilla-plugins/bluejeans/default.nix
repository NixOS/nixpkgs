{ stdenv, fetchurl, xorg, gtk2, glib, gdk_pixbuf, dpkg, libXext, libXfixes
, libXrender, libuuid, libXrandr, libXcomposite, libpulseaudio
}:

with stdenv.lib;

let

  rpathInstaller = makeLibraryPath
    [gtk2 glib stdenv.cc.cc];

  rpathPlugin = makeLibraryPath
    ([ stdenv.cc.cc gtk2 glib xorg.libX11 gdk_pixbuf libXext libXfixes libXrender libXrandr libXcomposite libpulseaudio ] ++ optional (libuuid != null) libuuid);

in

stdenv.mkDerivation rec {
  name = "bluejeans-${version}";

  version = "2.180.71.8";

  src = fetchurl {
    url = "https://swdl.bluejeans.com/skinny/bjnplugin_${version}-1_amd64.deb";
    sha256 = "1fgjgzss0ghk734xpfidazyknfdn11pmyw77pc3wigl83dvx4nb2";
  };

  unpackPhase = "${dpkg}/bin/dpkg-deb -x $src .";

  installPhase =
    ''
      mkdir -p $out
      cp -R usr/lib $out/

      plugins=$out/lib/mozilla/plugins
      patchelf \
        --set-rpath "${rpathPlugin}" \
        $plugins/npbjnplugin_${version}.so

      patchelf \
        --set-rpath "${rpathInstaller}" \
        $plugins/npbjninstallplugin_${version}.so
    '';

  dontStrip = true;
  dontPatchELF = true;

  passthru.mozillaPlugin = "/lib/mozilla/plugins";

  meta = {
    homepage = http://bluejeans.com;
    license = stdenv.lib.licenses.unfree;
    maintainers = with maintainers; [ ocharles kamilchm ];
    platforms = stdenv.lib.platforms.linux;
  };
}
