{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  freetype,
  glib,
  libGL,
  libGLU,
  libSM,

  libXrender,
  libX11,

  libxcb,
  sqlite,
  zlib,
  fontconfig,
  dpkg,
  libproxy,
  libxml2,
  gst_all_1,
  dbus,
  makeWrapper,

  cups,
  alsa-lib,

  xkeyboardconfig,
  autoPatchelfHook,
}:
let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "amd64"
    else
      throw "Unsupported system ${stdenv.hostPlatform.system} ";
in
mkDerivation rec {
  pname = "googleearth-pro";
  version = "7.3.4.8248";

  src = fetchurl {
    url = "https://dl.google.com/linux/earth/deb/pool/main/g/google-earth-pro-stable/google-earth-pro-stable_${version}-r0_${arch}.deb";
    sha256 = "1pbapi267snlrjari5k93y6kbrjsqhqxgkxxqaqv4r25az00dx6d";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  propagatedBuildInputs = [ xkeyboardconfig ];
  buildInputs = [
    dbus
    cups
    fontconfig
    freetype
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libGL
    libGLU
    libSM
    libX11
    libXrender
    libproxy
    libxcb
    libxml2
    sqlite
    zlib
    alsa-lib
  ];

  doInstallCheck = true;

  dontBuild = true;

  unpackPhase = ''
    # deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    mkdir deb
    dpkg --fsys-tarfile ${src} | tar --extract -C deb
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv deb/usr/* $out/
    rmdir deb/usr
    mv deb/* $out/
    rm $out/bin/google-earth-pro $out/opt/google/earth/pro/googleearth

    # patch and link googleearth binary
    ln -s $out/opt/google/earth/pro/googleearth-bin $out/bin/googleearth-pro

    # patch and link gpsbabel binary
    ln -s $out/opt/google/earth/pro/gpsbabel $out/bin/gpsbabel

    # Add desktop config file and icons
    mkdir -p $out/share/{applications,icons/hicolor/{16x16,22x22,24x24,32x32,48x48,64x64,128x128,256x256}/apps,pixmaps}
    ln -s $out/opt/google/earth/pro/google-earth-pro.desktop $out/share/applications/google-earth-pro.desktop
    sed -i -e "s|Exec=.*|Exec=$out/bin/googleearth-pro|g" $out/opt/google/earth/pro/google-earth-pro.desktop
    for size in 16 22 24 32 48 64 128 256; do
      ln -s $out/opt/google/earth/pro/product_logo_"$size".png $out/share/icons/hicolor/"$size"x"$size"/apps/google-earth-pro.png
    done
    ln -s $out/opt/google/earth/pro/product_logo_256.png $out/share/pixmaps/google-earth-pro.png

    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/gpsbabel -V > /dev/null
  '';

  # wayland is not supported by Qt included in binary package, so make sure it uses xcb
  postFixup = ''
    wrapProgram $out/bin/googleearth-pro \
      --set QT_QPA_PLATFORM xcb \
      --set QT_XKB_CONFIG_ROOT "${xkeyboardconfig}/share/X11/xkb"
  '';

  meta = with lib; {
    description = "A world sphere viewer";
    homepage = "https://www.google.com/earth/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      friedelino
      shamilton
    ];
    platforms = platforms.linux;
    knownVulnerabilities = [
      "Includes vulnerable versions of bundled libraries: openssl, ffmpeg, gdal, and proj."
    ];
  };
}
