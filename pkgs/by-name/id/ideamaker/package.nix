{
  autoPatchelfHook,
  boost,
  c-blosc,
  common-updater-scripts,
  copyDesktopItems,
  curl,
  dpkg,
  fetchFromGitHub,
  fetchurl,
  ilmbase,
  jemalloc,
  jq,
  lib,
  libcork,
  libGLU,
  libsForQt5,
  makeDesktopItem,
  nlopt,
  opencascade-occt_7_6,
  openssl_1_1,
  openvdb,
  poly2tri-c,
  shared-mime-info,
  stdenv,
  tbb,
  unzip,
  writeShellApplication,
  automake,
  libtool,
  pkgconf,
  autoconf,
  zlib,
}:
let
  pname = "ideamaker";
  version = "5.1.4.8480";
  semver = lib.strings.concatStringsSep "." (lib.lists.init (builtins.splitVersion version));
  description = "Raise3D's 3D slicer software";
  openexr_2_2_1 = stdenv.mkDerivation rec {
    name = "openexr-2.2.1";

    src = fetchurl {
      url = "http://download.savannah.nongnu.org/releases/openexr/${name}.tar.gz";
      sha256 = "1kdf2gqznsdinbd5vcmqnif442nyhdf9l7ckc51410qm2gv5m6lg";
    };

    patches = [
      ./bootstrap.patch
    ];

    outputs = [
      "bin"
      "dev"
      "out"
      "doc"
    ];

    preConfigure = ''
      ./bootstrap
    '';

    nativeBuildInputs = [ pkgconf ];
    buildInputs = [
      autoconf
      automake
      libtool
    ];
    propagatedBuildInputs = [
      ilmbase
      zlib
    ];

    enableParallelBuilding = true;

    meta = {
      homepage = "http://www.openexr.com/";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [ wkennington ];
    };
  };

  openvdb_5_0_0 = (
    openvdb.overrideAttrs {
      # attempting to build https://github.com/NixOS/nixpkgs/commit/7053b097de9334b07f6b74476b6b206542695731
      version = "5.0.0";
      outputs = [ "out" ];
      src = fetchFromGitHub {
        owner = "AcademySoftwareFoundation";
        repo = "openvdb";
        rev = "v5.0.0";
        sha256 = "sha256-OzttcC8QfGirBI4Yb0EBCxDK4gvCsP5WOMX59vINVJg=";
      };

      nativeBuildInputs = [ ];

      buildInputs = [
        unzip
        openexr_2_2_1
        boost
        tbb
        jemalloc
        c-blosc
        ilmbase
      ];

      cmakeFlags = [ ];

      postFixup = "";

      setSourceRoot = ''
        sourceRoot=$(echo */openvdb)
      '';

      installTargets = "install_lib";

      enableParallelBuilding = true;

      buildFlags = ''
        lib
        DESTDIR=$(out)
        HALF_LIB=-lHalf
        TBB_LIB=-ltbb
        BLOSC_LIB=-lblosc
        LOG4CPLUS_LIB=
        BLOSC_INCLUDE_DIR=${c-blosc}/include/
        BLOSC_LIB_DIR=${c-blosc}/lib/
      '';

      installFlags = ''DESTDIR=$(out)'';

      NIX_CFLAGS_COMPILE = "-I${openexr_2_2_1.dev}/include/OpenEXR -I${ilmbase.dev}/include/OpenEXR/";
      NIX_LDFLAGS = "-lboost_iostreams";
    }
  );
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchurl {
    url = "https://downcdn.raise3d.com/ideamaker/release/${semver}/ideaMaker_${version}-ubuntu_amd64.deb";
    hash = "sha256-vOiHqdegFHqA1PYYvtXBQSIl+OVq2oyAT80ZFtaIxl8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dpkg
    shared-mime-info
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    curl
    libcork
    libGLU
    libsForQt5.quazip
    nlopt
    opencascade-occt_7_6
    openssl_1_1
    openvdb_5_0_0
    poly2tri-c
    tbb
  ];

  installPhase = ''
    runHook preInstall

    install -D usr/lib/x86_64-linux-gnu/ideamaker/ideamaker \
      $out/bin/ideamaker

    mkdir $out/lib
    cp -a usr/lib/x86_64-linux-gnu/ideamaker/libIM* $out/lib

    patchelf --replace-needed libquazip.so.1 libquazip1-qt5.so $out/lib/*
    patchelf --replace-needed libpoly2tri.so.1 libpoly2tri-c-0.1.so $out/lib/*

    mimetypeDir=$out/share/icons/hicolor/128x128/mimetypes
    mkdir -p ''$mimetypeDir
    for file in usr/share/ideamaker/icons/*.ico; do
      mv $file ''$mimetypeDir/''$(basename ''${file%.ico}).png
    done
    install -D ${./mimetypes.xml} \
      $out/share/mime/packages/ideamaker.xml

    install -D usr/share/ideamaker/icons/ideamaker-icon.png \
      $out/share/pixmaps/ideamaker.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ideamaker";
      exec = "ideamaker";
      icon = "ideamaker";
      desktopName = "Ideamaker";
      comment = "ideaMaker - www.raise3d.com";
      categories = [
        "Qt"
        "Utility"
        "3DGraphics"
        "Viewer"
        "Engineering"
      ];
      genericName = description;
      mimeTypes = [
        "application/x-ideamaker"
        "model/3mf"
        "model/obj"
        "model/stl"
        "text/x.gcode"
      ];
      noDisplay = false;
      startupNotify = true;
      terminal = false;
      type = "Application";
    })
  ];

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "ideamaker-update-script";
    runtimeInputs = [
      curl
      common-updater-scripts
      jq
    ];
    text = ''
      update-source-version ideamaker "$(
        curl 'https://api.raise3d.com/ideamakerio-v1.1/hq/ofpVersionControl/find' -X 'POST' \
        | jq -r '.data.release_version.linux_64_deb_url' \
        | sed -E 's#.*/release/([0-9]+\.[0-9]+\.[0-9]+)/ideaMaker_\1\.([0-9]+).*#\1.\2#'
      )"
    '';
  });

  meta = {
    inherit description;
    homepage = "https://www.raise3d.com/ideamaker/";
    changelog = "https://www.raise3d.com/download/ideamaker-release-notes/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ cjshearer ];
  };
}
