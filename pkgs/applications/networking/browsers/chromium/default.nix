{ GConf, alsaLib, bzip2, cairo, cups, dbus, dbus_glib, expat
, fetchurl, ffmpeg, fontconfig, freetype, gtkLibs, libX11
, libXScrnSaver, libXdamage, libXext, libXrender, libXt, libXtst
, libgcrypt, libjpeg, libpng, makeWrapper, nspr, nss, patchelf
, stdenv, unzip, zlib, pam }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" ;

stdenv.mkDerivation rec {
  name = "chrome-${version}";
  version = "78873";
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://build.chromium.org/f/chromium/continuous/linux64/2011-03-21/${version}/chrome-linux.zip";
        sha256 = "04jmk4hfj305iyc6mi26iy617q4hd8341vfnl830qy02cp8pwf03";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://build.chromium.org/f/chromium/continuous/linux/2011-03-21/${version}/chrome-linux.zip";
        sha256 = "0jilfj5kk6zwr02m6982ss7xxnalmny8ml6m5k91h6gnlsrgi808";
      }
    else throw "Chromium is not supported on this platform.";

  phases = "unpackPhase installPhase";

  buildInputs = [makeWrapper unzip];

  libPath =
    stdenv.lib.makeLibraryPath
       [ GConf alsaLib bzip2 cairo cups dbus dbus_glib expat
         ffmpeg fontconfig freetype libX11 libXScrnSaver
         libXdamage libXext libXrender libXt libXtst libgcrypt libjpeg
         libpng nspr nss stdenv.gcc.gcc zlib stdenv.gcc.libc
         gtkLibs.glib gtkLibs.gtk gtkLibs.gdk_pixbuf gtkLibs.pango
         pam
       ];

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

  meta =  with stdenv.lib; {
    description = "Chromium, an open source web browser";
    homepage = http://www.chromium.org/;
    maintainers = [ maintainers.goibhniu ];
    license = licenses.bsd3;
  };
}
