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
  name = "bluejeans-${version}";

  version = "2.100.102.8";

  src = fetchurl {
    url = "https://swdl.bluejeans.com/skinny/bjnplugin_${version}-1_amd64.deb";
    sha256 = "18f8jmhxvqy1yiiwlsssj7rjlfcb41xn16hnl6wv8r8r2mmic4v8";
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
  };
}
