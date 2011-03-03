{ GConf, alsaLib, atk, bzip2, cairo, cups, dbus, dbus_glib, expat,
  fetchurl, ffmpeg, fontconfig, freetype, glib, gtk, libX11,
  libXScrnSaver, libXdamage, libXext, libXrender, libXt, libXtst,
  libgcrypt, libjpeg, libpng, makeWrapper, nspr, nss, pango, patchelf,
  stdenv, unzip, zlib }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" ;

stdenv.mkDerivation rec {
  name = "chrome-${version}";
  version = "75853";
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://build.chromium.org/f/chromium/continuous/linux64/2011-02-23/${version}/chrome-linux.zip";
        sha256 = "1bh507j1pm3qrkj8afzhmqicza5nms6f4dc9848xjgcvj9x2qii7";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://build.chromium.org/f/chromium/continuous/linux/2011-02-23/${version}/chrome-linux.zip";
        sha256 = "0rq888yvw5zsh0c3jnp115y4sl1q5kn4pz8flnwhrh35ca15lchn";
      }
    else throw "Chromium is not supported on this platform.";

  phases = "unpackPhase installPhase";

  buildInputs = [makeWrapper unzip];

  libPath =
    stdenv.lib.makeLibraryPath
       [ GConf alsaLib atk bzip2 cairo cups dbus dbus_glib expat
         ffmpeg fontconfig freetype glib gtk libX11 libXScrnSaver
         libXdamage libXext libXrender libXt libXtst libgcrypt libjpeg
         libpng nspr nss pango stdenv.gcc.gcc zlib stdenv.gcc.libc ];

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
