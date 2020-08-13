{ stdenv
, fetchurl
, rpmextract
, libnotify
, libuuid
, cairo
, cups
, pango
, fontconfig
, udev
, dbus
, gtk3
, atk
, at-spi2-atk
, expat
, gdk-pixbuf
, freetype
, nspr
, glib
, nss
, libX11
, libXrandr
, libXrender
, libXtst
, libXdamage
, libxcb
, libXcursor
, libXi
, libXext
, libXfixes
, libXft
, libXcomposite
, libXScrnSaver
, alsaLib
, pulseaudio
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "bluejeans";
  version = "2.4.0";

  src = fetchurl {
    url = "https://swdl.bluejeans.com/desktop-app/linux/${version}/BlueJeans.rpm";
    sha256 = "180hc854ngwfn6y6nsrfn74rv78cxhq6sgshrca5zqv6wq3l98g0";
  };

  nativeBuildInputs = [ rpmextract makeWrapper ];

  libPath =
    stdenv.lib.makeLibraryPath
      [
        libnotify
        libuuid
        cairo
        cups
        pango
        fontconfig
        gtk3
        atk
        at-spi2-atk
        expat
        gdk-pixbuf
        dbus
        udev.lib
        freetype
        nspr
        glib
        stdenv.cc.cc.lib
        nss
        libX11
        libXrandr
        libXrender
        libXtst
        libXdamage
        libxcb
        libXcursor
        libXi
        libXext
        libXfixes
        libXft
        libXcomposite
        libXScrnSaver
        alsaLib
        pulseaudio
      ];

  localtime64_stub = ./localtime64_stub.c;

  buildCommand = ''
    mkdir -p $out/bin/
    cd $out
    rpmextract $src
    mv usr/share share
    rmdir usr

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --replace-needed libudev.so.0 libudev.so.1 \
      opt/BlueJeans/bluejeans-v2
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      opt/BlueJeans/resources/BluejeansHelper

    cc $localtime64_stub -shared -o "$out"/opt/BlueJeans/liblocaltime64_stub.so

    makeWrapper $out/opt/BlueJeans/bluejeans-v2 $out/bin/bluejeans \
      --set LD_LIBRARY_PATH "${libPath}":"${placeholder "out"}"/opt/BlueJeans \
      --set LD_PRELOAD "$out"/opt/BlueJeans/liblocaltime64_stub.so

    substituteInPlace "$out"/share/applications/bluejeans-v2.desktop \
      --replace "/opt/BlueJeans/bluejeans-v2" "$out/bin/bluejeans"

    patchShebangs "$out"
  '';

  meta = with stdenv.lib; {
    description = "Video, audio, and web conferencing that works together with the collaboration tools you use every day";
    homepage = "https://www.bluejeans.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ veprbl ];
    platforms = [ "x86_64-linux" ];
  };
}
