{ GConf, alsaLib, bzip2, cairo, cups, dbus, dbus_glib, expat
, fetchurl, ffmpeg, fontconfig, freetype, gtkLibs, libX11
, libXScrnSaver, libXdamage, libXext, libXrender, libXt, libXtst
, libgcrypt, libjpeg, libpng, makeWrapper, nspr, nss, patchelf
, stdenv, unzip, zlib, pam, pcre }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" ;

stdenv.mkDerivation rec {
  name = "chromium-16.0.879.0-pre${version}";

  # To determine the latest revision, get
  # ‘http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux/LAST_CHANGE’.
  # For the version number, see ‘about:config’.
  version = "100626";
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux_x64/${version}/chrome-linux.zip";
        sha256 = "1dymz7h9v5hkivn6qn26bnj1waw60z3mngh8g46yvvc5xn4npc3l";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux/${version}/chrome-linux.zip";
        sha256 = "0zqaj90lfzdddbs6sjygmyxlh8nw3xfr9xw450g9cabg6a2sh7ca";
      }
    else throw "Chromium is not supported on this platform.";

  phases = "unpackPhase installPhase";

  buildInputs = [ makeWrapper unzip ];

  libPath =
    stdenv.lib.makeLibraryPath
       [ GConf alsaLib bzip2 cairo cups dbus dbus_glib expat
         ffmpeg fontconfig freetype libX11 libXScrnSaver
         libXdamage libXext libXrender libXt libXtst libgcrypt libjpeg
         libpng nspr stdenv.gcc.gcc zlib stdenv.gcc.libc
         gtkLibs.glib gtkLibs.gtk gtkLibs.gdk_pixbuf gtkLibs.pango
         pam
       ];

  installPhase = ''
    ensureDir $out/bin
    ensureDir $out/libexec/chrome

    cp -R * $out/libexec/chrome

    strip $out/libexec/chrome/chrome
    
    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}:$out/lib:${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib \
      $out/libexec/chrome/chrome

    makeWrapper $out/libexec/chrome/chrome $out/bin/chrome \
      --prefix LD_LIBRARY_PATH : "${pcre}/lib:${nss}/lib"
  '';

  meta =  with stdenv.lib; {
    description = "Chromium, an open source web browser";
    homepage = http://www.chromium.org/;
    maintainers = [ maintainers.goibhniu ];
    license = licenses.bsd3;
  };
}
