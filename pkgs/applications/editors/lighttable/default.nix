{ stdenv, fetchurl, buildEnv, makeDesktopItem, makeWrapper, zlib, glib, alsaLib
, dbus, gtk, atk, pango, freetype, fontconfig, libgnome_keyring3, gdk_pixbuf
, cairo, cups, expat, libgpgerror, nspr, gnome3, nss, xlibs, udev
}:

let
  libPath = stdenv.lib.makeLibraryPath [
      stdenv.gcc.gcc zlib glib dbus gtk atk pango freetype libgnome_keyring3 nss
      fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr gnome3.gconf
      xlibs.libXrender xlibs.libX11 xlibs.libXext xlibs.libXdamage xlibs.libXtst
      xlibs.libXcomposite xlibs.libXi xlibs.libXfixes
];
in
assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "LightTable-${version}";
  version = "0.6.7";

  src = 
    if stdenv.system == "i686-linux" then
      fetchurl {
        name = "LightTableLinux.tar.gz";
        url = https://d35ac8ww5dfjyg.cloudfront.net/playground/bins/0.6.7/LightTableLinux.tar.gz;
        sha256 = "3b09f9665ed1b4abb7c1ca16286ac7222caf6dc124059be6db4cb9f5fd041e73";
      }
    else
      fetchurl {
        name = "LightTableLinux64.tar.gz";
        url = https://d35ac8ww5dfjyg.cloudfront.net/playground/bins/0.6.7/LightTableLinux64.tar.gz;
        sha256 = "710d670ccc30aadba521ccb723388679ee6404aac662297a005432c811d59e82";
      };

  buildInputs = [ makeWrapper ];
  phases = [ "installPhase" ];

  installPhase = ''
    tar xvf ${src}
    mkdir -p $out/bin
    mv LightTable $out/

    patchelf \
      --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}:${stdenv.gcc.gcc}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
      $out/LightTable/ltbin

    ln -s ${udev}/lib/libudev.so.1 $out/LightTable/libudev.so.0

    makeWrapper $out/LightTable/ltbin $out/bin/lighttable \
      --prefix "LD_LIBRARY_PATH" : $out/LightTable
  '';

  meta = with stdenv.lib; {
    description = "the next generation code editor";
    homepage = http://www.lighttable.com/;
    license = [ licenses.gpl3 ];
  };
}
