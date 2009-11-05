{ stdenv
, fetchurl
, ffmpeg
, cairo
, pango
, glib
, libXrender
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
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" ;

stdenv.mkDerivation rec {
  name = "chrome-${version}";
  version = "31080";
  src = 
    if stdenv.system == "x86_64-linux" then 
      fetchurl {
        url = "http://build.chromium.org/buildbot/snapshots/chromium-rel-linux-64/${version}/chrome-linux.zip";
        sha256 = "1km6mrhzgdlhy7pl60g8wh8hlxp0ymv6rqpp3aqd94mqj9g5asm9";
      } 
    else if stdenv.system == "i686-linux" then 
      fetchurl {
        url = "http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/${version}/chrome-linux.zip";
        sha256 = "12awdamkkcb8kq2z7kila00yhn9msihq7b6970k9hghbwq95hjrk";
      } 
    else null;

  phases="unpackPhase installPhase";

  buildInputs = [makeWrapper unzip];

  libPath = 
    stdenv.lib.makeLibraryPath
       [ stdenv.glibc stdenv.gcc.gcc ffmpeg cairo pango glib libXrender gtk nspr nss fontconfig freetype alsaLib libX11 GConf libXext atk libXt expat zlib] ;

  installPhase = ''
    ensureDir $out/bin
    ensureDir $out/chrome
    ensureDir $out/lib

    cp -R * $out/chrome
    ln -s $out/chrome/chrome $out/bin/chrome
  
    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" --set-rpath ${libPath}:$out/lib:${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib $out/chrome/chrome 

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
