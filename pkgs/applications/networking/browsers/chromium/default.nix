{ GConf, alsaLib, atk, bzip2, cairo, cups, dbus, dbus_glib,
  expat, fetchurl, ffmpeg, fontconfig, freetype, glib, gtk,
  libX11, libXScrnSaver, libXdamage, libXext, libXrender, libXt,
  libgcrypt, libjpeg, libpng, makeWrapper, nspr, nss, pango,
  patchelf, stdenv, unzip, zlib }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" ;

stdenv.mkDerivation rec {
  name = "chrome-${version}";
  version = "65039";
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://build.chromium.org/buildbot/snapshots/chromium-rel-linux-64/${version}/chrome-linux.zip";
        sha256 = "1ad7kwd1w1958mb3pwzhshawrf2nlxdsf0gy7d2q4qnx5d809vws";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/${version}/chrome-linux.zip";
        sha256 = "06hz3gvv3623ldrj141w3mnzw049yylvv9b9q5r6my8icm722phf";
      }
    else throw "Chromium is not supported on this platform.";

  phases = "unpackPhase installPhase";

  buildInputs = [makeWrapper unzip];

  libPath =
    stdenv.lib.makeLibraryPath
       [ GConf alsaLib atk bzip2 cairo cups dbus dbus_glib expat
         ffmpeg fontconfig freetype glib gtk libX11 libXScrnSaver
         libXdamage libXext libXrender libXt libgcrypt libjpeg libpng
         nspr nss pango stdenv.gcc.gcc zlib stdenv.gcc.libc ];

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
