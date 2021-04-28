{ lib, stdenv, fetchurl, glibc, libGLU, libGL, freetype, glib, libSM, libICE, libXi, libXv
, libXrender, libXrandr, libXfixes, libXcursor, libXinerama, libXext, libX11, libXcomposite
, libxcb, sqlite, zlib, fontconfig, dpkg, libproxy, libxml2, gst_all_1, dbus, makeWrapper }:

let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "amd64"
    else throw "Unsupported system ${stdenv.hostPlatform.system} ";
  fullPath = lib.makeLibraryPath [
    glibc
    glib
    stdenv.cc.cc
    libSM
    libICE
    libXi
    libXv
    libGLU libGL
    libXrender
    libXrandr
    libXfixes
    libXcursor
    libXinerama
    libXcomposite
    freetype
    libXext
    libX11
    libxcb
    sqlite
    zlib
    fontconfig
    libproxy
    libxml2
    dbus
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];
in
stdenv.mkDerivation rec {
  pname = "googleearth-pro";
  version = "7.3.3.7786";

  src = fetchurl {
    url = "https://dl.google.com/linux/earth/deb/pool/main/g/google-earth-pro-stable/google-earth-pro-stable_${version}-r0_${arch}.deb";
    sha256 = "1s3cakwrgf702g33rh8qs657d8bl68wgg8k89rksgvswwpd2zbb3";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  doInstallCheck = true;

  dontBuild = true;

  dontPatchELF = true;

  unpackPhase = ''
    # deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile ${src} | tar --extract
  '';

  installPhase =''
    mkdir $out
    mv usr/* $out/
    rmdir usr
    mv * $out/
    rm $out/bin/google-earth-pro $out/opt/google/earth/pro/googleearth

    # patch and link googleearth binary
    ln -s $out/opt/google/earth/pro/googleearth-bin $out/bin/googleearth-pro
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${fullPath}:\$ORIGIN" \
      $out/opt/google/earth/pro/googleearth-bin

    # patch and link gpsbabel binary
    ln -s $out/opt/google/earth/pro/gpsbabel $out/bin/gpsbabel
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${fullPath}:\$ORIGIN" \
      $out/opt/google/earth/pro/gpsbabel

    # patch libraries
    for a in $out/opt/google/earth/pro/*.so* ; do
      patchelf --set-rpath "${fullPath}:\$ORIGIN" $a
    done

    # Add desktop config file and icons
    mkdir -p $out/share/{applications,icons/hicolor/{16x16,22x22,24x24,32x32,48x48,64x64,128x128,256x256}/apps,pixmaps}
    ln -s $out/opt/google/earth/pro/google-earth-pro.desktop $out/share/applications/google-earth-pro.desktop
    sed -i -e "s|Exec=.*|Exec=$out/bin/googleearth-pro|g" $out/opt/google/earth/pro/google-earth-pro.desktop
    for size in 16 22 24 32 48 64 128 256; do
      ln -s $out/opt/google/earth/pro/product_logo_"$size".png $out/share/icons/hicolor/"$size"x"$size"/apps/google-earth-pro.png
    done
    ln -s $out/opt/google/earth/pro/product_logo_256.png $out/share/pixmaps/google-earth-pro.png
  '';

  installCheckPhase = ''
    $out/bin/gpsbabel -V > /dev/null
  '';

  # wayland is not supported by Qt included in binary package, so make sure it uses xcb
  fixupPhase = ''
    wrapProgram $out/bin/googleearth-pro --set QT_QPA_PLATFORM xcb
  '';


  meta = with lib; {
    description = "A world sphere viewer";
    homepage = "https://earth.google.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ friedelino ];
    platforms = platforms.linux;
  };
}
