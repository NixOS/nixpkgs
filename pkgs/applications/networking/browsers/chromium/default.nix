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
, patchelf05
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" ;

stdenv.mkDerivation rec {
  name = "chrome-20565";

  src = 
    if stdenv.system == "x86_64-linux" then 
      fetchurl {
        url = http://build.chromium.org/buildbot/snapshots/chromium-rel-linux-64/30565/chrome-linux.zip;
        sha256 = "0ngxbb27g6yqwllkbwyb41vldz00nr5r0rfb3b0arznql2dkynhy";
      } 
    else if stdenv.system == "i686-linux" then 
      fetchurl {
        url = http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/30565/chrome-linux.zip;
        sha256 = "0q5432zn9jhy54s0w0xgdc2y0h7a51b8acc782s7j179hcgfa30a";
      } 
    else null;

  phases="unpackPhase installPhase";

  buildInputs = [makeWrapper unzip];

  libPath = 
    stdenv.lib.makeLibraryPath
       [ stdenv.glibc stdenv.gcc.gcc ffmpeg cairo pango glib libXrender gtk nspr nss fontconfig freetype alsaLib libX11 GConf libXext atk libXt] ;

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
