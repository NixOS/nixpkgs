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
  version = "32599";
  src = 
    if stdenv.system == "x86_64-linux" then 
      fetchurl {
        url = "http://build.chromium.org/buildbot/snapshots/chromium-rel-linux-64/${version}/chrome-linux.zip";
        sha256 = "1wz24hrnnjggsjxsaa4spqg73p1f7bv4a8l2ys3kbkdp709fl6v8";
      } 
    else if stdenv.system == "i686-linux" then 
      fetchurl {
        url = "http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/${version}/chrome-linux.zip";
        sha256 = "16w6d7kp34jr1c4ym6y2h6llkq3d65rybj5hs46w1b8qri60q6aa";
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
