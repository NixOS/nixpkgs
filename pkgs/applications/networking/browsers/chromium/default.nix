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
  name = "chrome-${version}"; # !!! Shouldn't this be "chromium"?
  version = "59187";

  # TODO: Use a stable release that doesn't disappear every few days.  
  src = 
    if stdenv.system == "x86_64-linux" then 
      fetchurl {
        url = "http://build.chromium.org/buildbot/snapshots/chromium-rel-linux-64/${version}/chrome-linux.zip";
        sha256 = "14dk0c5fgh1q2iy4srfvc6nr8grpk5k5zgnx13464bkadr9s32gx";
      } 
    else if stdenv.system == "i686-linux" then 
      fetchurl {
        url = "http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/${version}/chrome-linux.zip";
        sha256 = "0ls2vl01psp25rhy0bjhfzjayw00rrnqmvcki8sl5kv9m581bn8s";
      } 
    else throw "Chromium is not supported on this platform.";

  phases = "unpackPhase installPhase";

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
    description = "Chromium, an open source web browser";
  };
}
