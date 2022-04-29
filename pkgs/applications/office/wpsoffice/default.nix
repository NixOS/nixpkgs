{ lib, stdenv
, mkDerivation
, fetchurl
, dpkg
, wrapGAppsHook
, wrapQtAppsHook
, alsa-lib
, atk
, bzip2
, cairo
, cups
, dbus
, expat
, ffmpeg
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
, xz
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
, steam
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "wpsoffice";
  version = "11.1.0.9615";

  src = fetchurl {
    url = "http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/9615/wps-office_11.1.0.9615.XA_amd64.deb";
    sha256 = "0dpd4njpizclllps3qagipycfws935rhj9k5gmdhjfgsk0ns188w";
  };
  unpackCmd = "dpkg -x $src .";
  sourceRoot = ".";

  postUnpack = lib.optionalString (version == "11.1.0.9505") ''
    # distribution is missing libjsapiservice.so, so we should not let
    # autoPatchelfHook fail on the following dead libraries
    rm opt/kingsoft/wps-office/office6/{libjsetapi.so,libjswppapi.so,libjswpsapi.so}
  '';

  nativeBuildInputs = [ dpkg wrapGAppsHook wrapQtAppsHook makeWrapper ];

  meta = with lib; {
    description = "Office suite, formerly Kingsoft Office";
    homepage = "https://www.wps.com/";
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ mlatus th0rgal ];
  };

  buildInputs = with xorg; [
    alsa-lib
    atk
    bzip2
    cairo
    dbus.lib
    expat
    ffmpeg
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
    xz
    nspr
    nss
    openssl
    pango
    qt4
    qtbase
    sqlite
    unixODBC
    zlib
    cups.lib
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

  installPhase = let
    steam-run = (steam.override {
      extraPkgs = p: buildInputs;
    }).run;
  in ''
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

    for i in wps wpp et wpspdf; do
      mv $out/bin/$i $out/bin/.$i-orig
      makeWrapper ${steam-run}/bin/steam-run $out/bin/$i \
        --add-flags $out/bin/.$i-orig \
        --argv0 $i
    done
  '';

  dontWrapQtApps = true;
  dontWrapGApps = true;
  postFixup = ''
    for f in "$out"/bin/*; do
      echo "Wrapping $f"
      wrapProgram "$f" \
        "''${gappsWrapperArgs[@]}" \
        "''${qtWrapperArgs[@]}"
    done
  '';
}
