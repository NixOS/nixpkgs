# Build tools
{ stdenv, fetchurl, dpkg,
  wrapGAppsHook, autoPatchelfHook,
# Dependencies
  alsaLib, atk, cairo, dbus, libsForQt5,
  expat, fontconfig, freetype, gdk-pixbuf,
  gtk2-x11, glib, primusLib, xorg,
  libtool, lzma, pango, nspr, qt5, qt4,
  nss, sqlite, libuuid, zlib, cups, file
}:
let
  runtimeLibPath = stdenv.lib.makeLibraryPath [
    cups.lib
  ];
in
stdenv.mkDerivation rec {
  pname = "wpsoffice";
  version = "11.1.0.9126";

  src = fetchurl {
    url = "http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/9126/wps-office_11.1.0.9126.XA_amd64.deb";
    sha256 = "10d5sgpl1i70rj2596i6865hj0xdlzwdrwiplz41zys6l4zbmfp7";
  };
  unpackCmd = "dpkg -x $src .";
  sourceRoot = ".";

  nativeBuildInputs = [ wrapGAppsHook qt5.wrapQtAppsHook dpkg autoPatchelfHook ];
  dontWrapQtApps = true;
  dontWrapGApps = true;
  
  buildInputs = [
    alsaLib atk cairo dbus.lib
    expat fontconfig.lib stdenv.cc.cc.lib
    freetype gdk-pixbuf gtk2-x11 glib
    xorg.libICE libtool.lib
    lzma pango nspr qt4 qt5.qtbase
    nss xorg.libSM sqlite libuuid
    xorg.libX11 xorg.libxcb
    xorg.libXcomposite xorg.libXcursor
    xorg.libXdamage xorg.libXfixes
    xorg.libXi xorg.libXrandr
    xorg.libXrender xorg.libXScrnSaver
    xorg.libXtst xorg.libXext zlib
    libsForQt5.qtstyleplugins
  ];

  meta = {
    description = "Office program originally named Kingsoft Office";
    homepage = http://wps-community.org/;
    platforms = [ "i686-linux" "x86_64-linux" ];
    hydraPlatforms = [];
    license = stdenv.lib.licenses.unfreeRedistributable;
    maintainers = [ stdenv.lib.maintainers.mlatus ];
  };

  dontPatchELF = true;

  # wpsoffice uses `/build` in its own build system making nix things there
  # references to nix own build directory
  noAuditTmpdir = true;

  installPhase = ''
    prefix=$out/opt/kingsoft/wps-office
    mkdir -p $out
    cp -r opt $out
    cp -r usr/* $out
    # Avoid forbidden reference error due use of patchelf
    rm -r *

    for i in et wpp wps wpspdf;do
      substituteInPlace $out/bin/$i \
        --replace /opt/kingsoft/wps-office $prefix
    done

    for i in $out/share/applications/*;do
      substituteInPlace $i \
        --replace /usr/bin $out/bin \
        --replace /opt/kingsoft/wps-office $prefix
    done
  '';

  postFixup = ''
    bins=$(find $prefix/office6 -maxdepth 1 -executable ! -type d|grep -v '.*\.so\.*')
    for i in $bins;do
      echo Wrapping $i
      wrapProgram $i \
        "''${gappsWrapperArgs[@]}" \
        "''${qtWrapperArgs[@]}" \
        --suffix LD_LIBRARY_PATH : ${runtimeLibPath}
    done
  '';
}
