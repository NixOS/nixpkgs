{ stdenv
, fetchurl
, ffmpeg
, cairo
, pango
, glib
, libXrender
, libXScrnSaver
, gtk
, nspr
, nss
, fontconfig
, freetype
, alsaLib
, libX11
, GConf
, libXext
, libXt
, atk
, makeWrapper
, unzip
, expat
, zlib
, libjpeg
, bzip2
, libpng
, dbus
, dbus_glib
, patchelf
, cups
, libgcrypt
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" ;

stdenv.mkDerivation rec {
  name = "chrome-${version}";
  version = "55366";
  src = 
    if stdenv.system == "x86_64-linux" then 
      fetchurl {
        url = "http://build.chromium.org/buildbot/snapshots/chromium-rel-linux-64/${version}/chrome-linux.zip";
        sha256 = "1dazdfpnl278wwh03hs0x184ql5zh0yhpfiaw75j437dp3668hnj";
      } 
    else if stdenv.system == "i686-linux" then 
      fetchurl {
        url = "http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/${version}/chrome-linux.zip";
        sha256 = "1x5ykvp2hxc56p4bb1lykahkk1nzkqi2kkm474spplqcfnmd6j2b";
      } 
    else null;

  phases="unpackPhase installPhase";

  buildInputs = [makeWrapper unzip];

  libPath = 
    stdenv.lib.makeLibraryPath
       [ stdenv.gcc.libc stdenv.gcc.gcc ffmpeg cairo pango glib libXrender gtk nspr nss fontconfig freetype alsaLib libX11 GConf libXext atk libXt expat zlib libjpeg bzip2 libpng libXScrnSaver dbus dbus_glib cups libgcrypt] ;

  installPhase = ''
    ensureDir $out/bin
    ensureDir $out/chrome
    ensureDir $out/lib

    cp -R * $out/chrome
    ln -s $out/chrome/chrome $out/bin/chrome
    ${patchelf}/bin/patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" --set-rpath ${libPath}:$out/lib:${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib $out/chrome/chrome 
        

    ln -s ${nss}/lib/libsmime3.so $out/lib/libsmime3.so.1d
    ln -s ${nss}/lib/libnssutil3.so $out/lib/libnssutil3.so.1d
    ln -s ${nss}/lib/libssl3.so $out/lib/libssl3.so.1d
    ln -s ${nss}/lib/libnss3.so $out/lib/libnss3.so.1d
    ln -s ${nspr}/lib/libnspr4.so $out/lib/libnspr4.so.0d
    ln -s ${nspr}/lib/libplds4.so $out/lib/libplds4.so.0d
    ln -s ${nspr}/lib/libplc4.so $out/lib/libplc4.so.0d
  '';

  meta = {
    description = "";
  };
}
