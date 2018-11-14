{ stdenv, fetchurl, glibc, libGLU_combined, freetype, glib, libSM, libICE, libXi, libXv
, libXrender, libXrandr, libXfixes, libXcursor, libXinerama, libXext, libX11
, zlib, fontconfig, dpkg, libproxy, libxml2, gstreamer, gst_all_1, dbus }:

let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "amd64"
    else if stdenv.hostPlatform.system == "i686-linux" then "i386"
    else throw "Unsupported system ${stdenv.hostPlatform.system}";
  sha256 =
    if arch == "amd64"
    then "0dwnppn5snl5bwkdrgj4cyylnhngi0g66fn2k41j3dvis83x24k6"
    else "0gndbxrj3kgc2dhjqwjifr3cl85hgpm695z0wi01wvwzhrjqs0l2";
  version = "7.1.8.3036";
  fullPath = stdenv.lib.makeLibraryPath [
    glibc
    glib
    stdenv.cc.cc
    libSM
    libICE
    libXi
    libXv
    libGLU_combined
    libXrender
    libXrandr
    libXfixes
    libXcursor
    libXinerama
    freetype
    libXext
    libX11
    zlib
    fontconfig
    libproxy
    libxml2
    gstreamer
    dbus
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];
in
stdenv.mkDerivation rec {
  name = "googleearth-${version}";
  src = fetchurl {
    url = "https://dl.google.com/linux/earth/deb/pool/main/g/google-earth-stable/google-earth-stable_${version}-r0_${arch}.deb";
    inherit sha256;
  };

  phases = [ "unpackPhase" "installPhase" "checkPhase" ];

  doCheck = true;

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase =''
    mkdir $out
    mv usr/* $out/
    rmdir usr
    mv * $out/
    rm $out/bin/google-earth $out/opt/google/earth/free/googleearth

    # patch and link googleearth binary
    ln -s $out/opt/google/earth/free/googleearth-bin $out/bin/googleearth
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${fullPath}:\$ORIGIN" \
      $out/opt/google/earth/free/googleearth-bin

    # patch and link gpsbabel binary
    ln -s $out/opt/google/earth/free/gpsbabel $out/bin/gpsbabel
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${fullPath}:\$ORIGIN" \
      $out/opt/google/earth/free/gpsbabel

    # patch libraries
    for a in $out/opt/google/earth/free/*.so* ; do
      patchelf --set-rpath "${fullPath}:\$ORIGIN" $a
    done
  '';

  checkPhase = ''
    $out/bin/gpsbabel -V > /dev/null
  '';

  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "A world sphere viewer";
    homepage = http://earth.google.com;
    license = licenses.unfree;
    maintainers = with maintainers; [ markus1189 ];
    platforms = platforms.linux;
  };
}
