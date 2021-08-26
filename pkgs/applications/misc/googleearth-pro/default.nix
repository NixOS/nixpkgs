{ lib
, stdenv
, mkDerivation
, fetchurl
, ffmpeg_3
, freetype
, gdal_2
, glib
, libGL
, libGLU
, libICE
, libSM
, libXi
, libXv
, libav_12

, libXrender
, libXrandr
, libXfixes
, libXcursor
, libXinerama
, libXext
, libX11
, libXcomposite

, libxcb
, sqlite
, zlib
, fontconfig
, dpkg
, libproxy
, libxml2
, gst_all_1
, dbus
, makeWrapper

, qtlocation
, qtwebkit
, qtx11extras
, qtsensors
, qtscript

, xkeyboardconfig
, autoPatchelfHook
}:
let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "amd64"
    else throw "Unsupported system ${stdenv.hostPlatform.system} ";
in
mkDerivation rec {
  pname = "googleearth-pro";
  version = "7.3.3.7786";

  src = fetchurl {
    url = "https://dl.google.com/linux/earth/deb/pool/main/g/google-earth-pro-stable/google-earth-pro-stable_${version}-r0_${arch}.deb";
    sha256 = "1s3cakwrgf702g33rh8qs657d8bl68wgg8k89rksgvswwpd2zbb3";
  };

  nativeBuildInputs = [ dpkg makeWrapper autoPatchelfHook ];
  propagatedBuildInputs = [ xkeyboardconfig ];
  buildInputs = [
    dbus
    ffmpeg_3
    fontconfig
    freetype
    gdal_2
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libGL
    libGLU
    libICE
    libSM
    libX11
    libXcomposite
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
    libXv
    libav_12
    libproxy
    libxcb
    libxml2
    qtlocation
    qtscript
    qtsensors
    qtwebkit
    qtx11extras
    sqlite
    zlib
  ];

  doInstallCheck = true;

  dontBuild = true;

  unpackPhase = ''
    # deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile ${src} | tar --extract
  '';

  installPhase =''
    runHook preInstall

    mkdir $out
    mv usr/* $out/
    rmdir usr
    mv * $out/
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

  postInstall = ''
    find "$out/opt/google/earth/pro" -name "*.so.*" | \
      egrep -v 'libssl*|libcrypto*|libicu*' | \
      xargs rm
    find "$out/opt/google/earth/pro" -name "*.so" | \
      egrep -v 'libgoogle*|libauth*|libbase*|libcommon*|libcommon_gui*|libcommon_platform*|libcommon_webbrowser*|libcomponentframework*|libgeobase*|libgeobaseutils*|libge_net*|libgdata*|libgoogleapi*|libmath*|libmoduleframework*|libmaps*|libport*|libprintmodule*|libprofile*|librender*|libreporting*|libsgutil*|libspatial*|libxsltransform*|libbase*|libport*|libport*|libbase*|libcomponentframework*|libIGCore*|libIGUtils*|libaction*|libapiloader*|libapiloader*|libIGCore*|libIGUtils*|libIGMath*|libfusioncommon*|libge_exif*|libaction*|libfusioncommon*|libapiloader*|liblayer*|libapiloader*|libIGAttrs*|libIGCore*|libIGGfx*|libIGMath*|libIGSg*|libIGUtils*|libwmsbase*|libwebbrowser*|libevllpro*|libalchemyext*|libge_cache*|libflightsim*|libnpgeinprocessplugin*|libmeasure*|libviewsync*|libcapture*|libtheme*|libgps*|libgisingest*|libsearchmodule*|libinput_plugin*|libnavigate*|libspnav*|libsearch*|libLeap*' | \
      xargs rm
  '';

  autoPatchelfIgnoreMissingDeps=true;

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
    license = licenses.unfree;
    maintainers = with maintainers; [ friedelino shamilton ];
    platforms = platforms.linux;
  };
}
