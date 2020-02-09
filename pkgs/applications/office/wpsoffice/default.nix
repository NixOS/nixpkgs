{ stdenv, fetchurl
, libX11, glib, xorg, fontconfig, freetype
, zlib, libpng12, libICE, libXrender, cups
, alsaLib, atk, cairo, dbus, expat
, gdk-pixbuf, gtk2-x11, lzma, pango, zotero
, sqlite, libuuid, qt5, dpkg }:

stdenv.mkDerivation rec{
  pname = "wpsoffice";
  version = "11.1.0.9080";

  src = fetchurl {
    url = "http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/9080/wps-office_11.1.0.9080.XA_amd64.deb";
    sha256 = "1731e9aea22ef4e558ad66b1373d863452b4f570aecf09d448ae28a821333454";
  };
  unpackCmd = "dpkg -x $src .";
  sourceRoot = ".";

  nativeBuildInputs = [ qt5.wrapQtAppsHook dpkg ];

  meta = {
    description = "Office program originally named Kingsoft Office";
    homepage = http://wps-community.org/;
    platforms = [ "i686-linux" "x86_64-linux" ];
    hydraPlatforms = [];
    license = stdenv.lib.licenses.unfreeRedistributable;
    maintainers = [ stdenv.lib.maintainers.mlatus ];
  };

  libPath = with xorg; stdenv.lib.makeLibraryPath [
    libX11
    libpng12
    glib
    libSM
    libXext
    fontconfig
    zlib
    freetype
    libICE
    cups
    libXrender
    libxcb

    alsaLib
    atk
    cairo
    dbus.daemon.lib
    expat
    fontconfig.lib
    gdk-pixbuf
    gtk2-x11
    lzma
    pango
    zotero
    sqlite
    libuuid
    libXcomposite
    libXcursor
    libXdamage
    libXfixes
    libXi
    libXrandr
    libXScrnSaver
    libXtst
  ];

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
    for i in wps wpp et wpspdf; do
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --force-rpath --set-rpath "$(patchelf --print-rpath $prefix/office6/$i):${stdenv.cc.cc.lib}/lib64:${libPath}" \
        $prefix/office6/$i
      substituteInPlace $out/bin/$i \
        --replace /opt/kingsoft/wps-office $prefix
    done
    for i in $out/share/applications/*;do
      substituteInPlace $i \
        --replace /usr/bin $out/bin \
        --replace /opt/kingsoft/wps-office $prefix
    done
  '';
}