{ stdenv
, mkDerivation
, fetchurl
, autoPatchelfHook
, dpkg
, wrapGAppsHook
, wrapQtAppsHook
, alsaLib
, atk
, bzip2
, cairo
, cups
, dbus
, expat
, ffmpeg_3
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gperftools
, gtk2-x11
, libpng12
, libtool
, libuuid
, libxml2
, lzma
, nspr
, nss
, openssl
, pango
, qt4
, qtbase
, sqlite
, unixODBC
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "wpsoffice";
  version = "11.1.0.9505";

  src = fetchurl {
    url = "http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/9505/wps-office_11.1.0.9505.XA_amd64.deb";
    sha256 = "1bvaxwd3npw3kswk7k1p6mcbfg37x0ym4sp6xis6ykz870qivqk5";
  };
  unpackCmd = "dpkg -x $src .";
  sourceRoot = ".";

  postUnpack = stdenv.lib.optionalString (version == "11.1.0.9505") ''
    # distribution is missing libjsapiservice.so, so we should not let
    # autoPatchelfHook fail on the following dead libraries
    rm opt/kingsoft/wps-office/office6/{libjsetapi.so,libjswppapi.so,libjswpsapi.so}
  '';

  nativeBuildInputs = [ autoPatchelfHook dpkg wrapGAppsHook wrapQtAppsHook ];

  meta = {
    description = "Office program originally named Kingsoft Office";
    homepage = "http://wps-community.org/";
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [];
    license = stdenv.lib.licenses.unfreeRedistributable;
    maintainers = with stdenv.lib.maintainers; [ mlatus th0rgal ];
  };

  buildInputs = with xorg; [
    alsaLib
    atk
    bzip2
    cairo
    dbus.lib
    expat
    ffmpeg_3
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gperftools
    gtk2-x11
    libICE
    libSM
    libX11
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libpng12
    libtool
    libuuid
    libxcb
    libxml2
    lzma
    nspr
    nss
    openssl
    pango
    qt4
    qtbase
    sqlite
    unixODBC
    zlib
  ];

  dontPatchELF = true;

  # wpsoffice uses `/build` in its own build system making nix things there
  # references to nix own build directory
  noAuditTmpdir = true;

  unvendoredLibraries = [
    # Have to use parts of the vendored qt4
    #"Qt"
    "SDL2"
    "bz2"
    "avcodec"
    "avdevice"
    "avformat"
    "avutil"
    "swresample"
    "swscale"
    "jpeg"
    "png"
    # File saving breaks unless we are using vendored llvmPackages_8.libcxx
    #"c++"
    "ssl" "crypto"
    "nspr"
    "nss"
    "odbc"
    "tcmalloc" # gperftools
  ];

  installPhase = ''
    prefix=$out/opt/kingsoft/wps-office
    mkdir -p $out
    cp -r opt $out
    cp -r usr/* $out
    for lib in $unvendoredLibraries; do
      rm -v "$prefix/office6/lib$lib"*.so{,.*}
    done
    for i in wps wpp et wpspdf; do
      substituteInPlace $out/bin/$i \
        --replace /opt/kingsoft/wps-office $prefix
    done
    for i in $out/share/applications/*;do
      substituteInPlace $i \
        --replace /usr/bin $out/bin
    done
  '';

  runtimeLibPath = stdenv.lib.makeLibraryPath [
    cups.lib
  ];

  dontWrapQtApps = true;
  dontWrapGApps = true;
  postFixup = ''
    for f in "$out"/bin/*; do
      echo "Wrapping $f"
      wrapProgram "$f" \
        "''${gappsWrapperArgs[@]}" \
        "''${qtWrapperArgs[@]}" \
        --suffix LD_LIBRARY_PATH : "$runtimeLibPath"
    done
  '';
}
