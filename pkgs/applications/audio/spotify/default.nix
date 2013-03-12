{ fetchurl, stdenv, dpkg, xlibs, qt4, alsaLib, makeWrapper, openssl, freetype, glib, pango, cairo, atk, gdk_pixbuf, gtk, cups, nspr, nss, libpng12, GConf, libgcrypt, chromium, sqlite, gst_plugins_base, gstreamer }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let 
  version = "0.8.8.323"; 
  qt4webkit = 
    if stdenv.system == "i686-linux" then
      fetchurl {
        name = "libqtwebkit4_2.2_i386.deb";
        url = http://mirrors.us.kernel.org/ubuntu/pool/main/q/qtwebkit-source/libqtwebkit4_2.2~2011week36-0ubuntu1_i386.deb;
        sha256 = "0hi6cwx2b2cwa4nv5phqqw526lc8p9x7kjkcza9x47ny3npw2924";
      }
    else 
      fetchurl {
        name = "libqtwebkit4_2.2_amd64.deb";
        url = http://ie.archive.ubuntu.com/ubuntu/pool/main/q/qtwebkit-source/libqtwebkit4_2.2~2011week36-0ubuntu1_amd64.deb;
        sha256 = "0bvy6qz9y19ck391z8c049v07y4vdyvgykpxi7x1nvn078p1imiw";
      };
in

stdenv.mkDerivation {
  name = "spotify-${version}";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client_${version}.gd143501.250-1_i386.deb";
        sha256 = "13q803qlvq16yrr7f95izp9mqqdb8kpcsyrb5gc5i2pya68ra906";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client_${version}.gd143501.250-1_amd64.deb";
        sha256 = "0ny3z499wks1dhrd3qq4d6cp0zd33198z9vak8ffgm5x24sdpghf";
      }
    else throw "Spotify not supported on this platform.";

  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";

  installPhase =
    ''
      mkdir -p $out
      dpkg-deb -x $src $out
      mv $out/opt/spotify/* $out/
      rm -rf $out/usr $out/opt

      # Work around Spotify referring to a specific minor version of
      # OpenSSL.
      mkdir $out/lib
      ln -s ${openssl}/lib/libssl.so $out/lib/libssl.so.0.9.8
      ln -s ${openssl}/lib/libcrypto.so $out/lib/libcrypto.so.0.9.8
      ln -s ${nss}/lib/libnss3.so $out/lib/libnss3.so.1d
      ln -s ${nss}/lib/libnssutil3.so $out/lib/libnssutil3.so.1d
      ln -s ${nss}/lib/libsmime3.so $out/lib/libsmime3.so.1d
      ln -s ${nspr}/lib/libnspr4.so $out/lib/libnspr4.so.0d
      ln -s ${nspr}/lib/libplc4.so $out/lib/libplc4.so.0d

      mkdir -p $out/bin

      ln -s $out/spotify-client/spotify $out/bin/spotify
      patchelf \
        --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath $out/lib:$out/spotify-client:${stdenv.lib.makeLibraryPath [ xlibs.libXScrnSaver xlibs.libX11 qt4 alsaLib stdenv.gcc.gcc freetype glib pango cairo atk gdk_pixbuf gtk GConf cups sqlite]}:${stdenv.gcc.gcc}/lib64 \
        $out/spotify-client/spotify

      dpkg-deb -x ${qt4webkit} ./
      mkdir -p $out/lib/
      cp -v usr/lib/*/* $out/lib/

      preload=$out/libexec/spotify/libpreload.so
      mkdir -p $out/libexec/spotify
      gcc -shared ${./preload.c} -o $preload -ldl -DOUT=\"$out\" -fPIC

      wrapProgram $out/bin/spotify --set LD_PRELOAD $preload --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ GConf libpng12 cups libgcrypt sqlite gst_plugins_base gstreamer]}:$out/lib"
    ''; # */

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = https://www.spotify.com/download/previews/;
    description = "Spotify for Linux allows you to play music from the Spotify music service";
    license = "unfree";
    maintainers = [ stdenv.lib.maintainers.eelco ];

    longDescription =
      ''
        Spotify is a digital music streaming service.  This package
        provides the Spotify client for Linux.  At present, it does not
        work with free Spotify accounts; it requires a Premium or
        Unlimited account.
      '';
  };
}
