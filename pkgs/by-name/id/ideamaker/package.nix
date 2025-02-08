{
  autoPatchelfHook,
  common-updater-scripts,
  copyDesktopItems,
  curl,
  dpkg,
  e2fsprogs,
  fetchurl,
  gnutls,
  gtk3,
  jq,
  lib,
  libGLU,
  libpsl,
  libsForQt5,
  lz4,
  makeDesktopItem,
  nghttp2,
  shared-mime-info,
  stdenv,
  writeShellApplication,
}:
let
  pname = "ideamaker";
  version = "5.1.4.8480";
  semver = lib.strings.concatStringsSep "." (lib.lists.init (builtins.splitVersion version));
  description = "Raise3D's 3D slicer software";
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
    libGLU
    lz4
    e2fsprogs
    gnutls
    gtk3
    nghttp2
    libpsl
    # libsForQt5.qtbase
    # libsForQt5.qt5.qtwayland
  ];

  installPhase = ''
    runHook preInstall

    install -D usr/lib/x86_64-linux-gnu/ideamaker/ideamaker \
      $out/bin/ideamaker

    mkdir $out/lib
    # shopt -s extglob
    # cp -a usr/lib/x86_64-linux-gnu/ideamaker/!(libQt5*) $out/lib
    cp -a usr/lib/x86_64-linux-gnu/ideamaker/* $out/lib

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
