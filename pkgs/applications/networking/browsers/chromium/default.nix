{ GConf, alsaLib, bzip2, cairo, cups, dbus, dbus_glib, expat
, fetchurl, ffmpeg, fontconfig, freetype, libX11, libXfixes
, glib, gtk, gdk_pixbuf, pango
, libXScrnSaver, libXdamage, libXext, libXrender, libXt, libXtst, libXcomposite
, libgcrypt, libjpeg, libpng, makeWrapper, nspr, nss, patchelf
, stdenv, unzip, zlib, pam, pcre, udev }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" ;

stdenv.mkDerivation rec {
  name = "chromium-19.0.1061.0-pre${version}";

  # To determine the latest revision, get
  # ‘http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux/LAST_CHANGE’.
  # For the version number, see ‘about:version’.
  version = "124950";
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux_x64/${version}/chrome-linux.zip";
        sha256 = "4472bf584a96e477e2c17f96d4452dd41f4f34ac3d6a9bb4c845cf15d8db0c73";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux/${version}/chrome-linux.zip";
        sha256 = "6e8a49d9917ee26b67d14cd10b85711c3b9382864197ba02b3cfe8e636d3d69c";
      }
    else throw "Chromium is not supported on this platform.";

  phases = "unpackPhase installPhase";

  buildInputs = [ makeWrapper unzip ];

  libPath =
    stdenv.lib.makeLibraryPath
       [ GConf alsaLib bzip2 cairo cups dbus dbus_glib expat
         ffmpeg fontconfig freetype libX11 libXScrnSaver libXfixes libXcomposite
         libXdamage libXext libXrender libXt libXtst libgcrypt libjpeg
         libpng nspr stdenv.gcc.gcc zlib stdenv.gcc.libc
         glib gtk gdk_pixbuf pango
         pam udev
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
