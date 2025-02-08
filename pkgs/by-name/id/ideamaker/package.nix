{
  autoPatchelfHook,
  boost,
  c-blosc,
  common-updater-scripts,
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
  openexr,
  openssl_1_1,
  openvdb,
  poly2tri-c,
  shared-mime-info,
  stdenv,
  tbb,
  unzip,
  writeShellApplication,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ideamaker";
  version = "5.1.4.8480";
  src =
    let
      semver = lib.strings.concatStringsSep "." (
        lib.lists.init (builtins.splitVersion finalAttrs.version)
      );
    in
    fetchurl {
      url = "https://downcdn.raise3d.com/ideamaker/release/${semver}/ideaMaker_${finalAttrs.version}-ubuntu_amd64.deb";
      hash = "sha256-vOiHqdegFHqA1PYYvtXBQSIl+OVq2oyAT80ZFtaIxl8=";
    };

  nativeBuildInputs = [
    autoPatchelfHook
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
    (openvdb.overrideAttrs {
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
        openexr
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

      NIX_CFLAGS_COMPILE = "-I${openexr.dev}/include/OpenEXR -I${ilmbase.dev}/include/OpenEXR/";
      NIX_LDFLAGS = "-lboost_iostreams";
    })
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

    ln -s ${finalAttrs.desktopItem}/share/applications $out/share/

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
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
    genericName = finalAttrs.meta.description;
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
  };

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
    homepage = "https://www.raise3d.com/ideamaker/";
    changelog = "https://www.raise3d.com/download/ideamaker-release-notes/";
    description = "Raise3D's 3D slicer software";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
