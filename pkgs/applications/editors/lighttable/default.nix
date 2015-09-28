{ stdenv, fetchurl, buildEnv, makeDesktopItem, makeWrapper, zlib, glib, alsaLib
, dbus, gtk, atk, pango, freetype, fontconfig, libgnome_keyring3, gdk_pixbuf
, cairo, cups, expat, libgpgerror, nspr, gnome3, nss, xorg, udev
}:

let
  libPath = stdenv.lib.makeLibraryPath [
      stdenv.cc.cc zlib glib dbus gtk atk pango freetype libgnome_keyring3 nss
      fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr gnome3.gconf
      xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
      xorg.libXcomposite xorg.libXi xorg.libXfixes
];
in
assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "lighttable-${version}";
  version = "0.7.2";

  src = 
    if stdenv.system == "i686-linux" then
      fetchurl {
        name = "LightTableLinux.tar.gz";
        url = "https://d35ac8ww5dfjyg.cloudfront.net/playground/bins/${version}/LightTableLinux.tar.gz";
        sha256 = "1q5m50r319xn9drfv3cyfja87b7dfhni9d9gmz9733idq3l5fl9i";
      }
    else
      fetchurl {
        name = "LightTableLinux64.tar.gz";
        url = "https://d35ac8ww5dfjyg.cloudfront.net/playground/bins/${version}/LightTableLinux64.tar.gz";
        sha256 = "1jnn103v5qrplkb5ik9p8whfqclcq2r1qv666hp3jaiwb46vhf3c";
      };

  buildInputs = [ makeWrapper ];
  phases = [ "installPhase" ];

  installPhase = ''
    tar xvf ${src}
    mkdir -p $out/bin
    mv LightTable $out/

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}:${stdenv.cc.cc}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
      $out/LightTable/ltbin

    ln -sf ${udev}/lib/libudev.so.1 $out/LightTable/libudev.so.0

    makeWrapper $out/LightTable/ltbin $out/bin/lighttable \
      --prefix "LD_LIBRARY_PATH" : $out/LightTable
  '';

  meta = with stdenv.lib; {
    description = "the next generation code editor";
    homepage = http://www.lighttable.com/;
    license = licenses.gpl3;
  };
}
