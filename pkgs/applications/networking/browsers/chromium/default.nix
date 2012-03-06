{ GConf, alsaLib, bzip2, cairo, cups, dbus, dbus_glib, expat
, fetchurl, ffmpeg, fontconfig, freetype, gtkLibs, libX11, libXfixes
, libXScrnSaver, libXdamage, libXext, libXrender, libXt, libXtst
, libgcrypt, libjpeg, libpng, makeWrapper, nspr, nss, patchelf
, stdenv, unzip, zlib, pam, pcre }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" ;

stdenv.mkDerivation rec {
  name = "chromium-18.0.975.0-pre${version}";

  # To determine the latest revision, get
  # ‘http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux/LAST_CHANGE’.
  # For the version number, see ‘about:version’.
  version = "114925";
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux_x64/${version}/chrome-linux.zip";
        sha256 = "19ayrcz1vw7nqr3bbas5f414n3kibf7knd285azrk29f7a7dnpd6";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux/${version}/chrome-linux.zip";
        sha256 = "1bhcd3plw3r62bfysc9nszn07xv3gamf5lkwd6ardwyxanclc7x6";
      }
    else throw "Chromium is not supported on this platform.";

  phases = "unpackPhase installPhase";

  buildInputs = [ makeWrapper unzip ];

  libPath =
    stdenv.lib.makeLibraryPath
       [ GConf alsaLib bzip2 cairo cups dbus dbus_glib expat
         ffmpeg fontconfig freetype libX11 libXScrnSaver libXfixes
         libXdamage libXext libXrender libXt libXtst libgcrypt libjpeg
         libpng nspr stdenv.gcc.gcc zlib stdenv.gcc.libc
         gtkLibs.glib gtkLibs.gtk gtkLibs.gdk_pixbuf gtkLibs.pango
         pam
       ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/libexec/chrome

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
    maintainers = with stdenv.lib.maintainers; [ goibhniu chaoflow ];
    license = licenses.bsd3;
  };
}
