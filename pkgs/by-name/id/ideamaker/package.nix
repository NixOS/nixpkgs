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
  libredirect,
  libX11,
  lz4,
  makeDesktopItem,
  makeWrapper,
  nghttp2,
  shared-mime-info,
  stdenv,
  writeShellApplication,
  xkeyboardconfig,
}:
let
  pname = "ideamaker";
  version = "5.2.2.8570";
  semver = lib.strings.concatStringsSep "." (lib.lists.init (builtins.splitVersion version));
  description = "Raise3D's 3D slicer software";
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchurl {
    url = "https://downcdn.raise3d.com/ideamaker/release/${semver}/ideaMaker_${version}-ubuntu_amd64.deb";
    hash = "sha256-kXcgVuuPTMWoOCrEztiedJrZrTbFx1xHyzzh4y2b0UA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dpkg
    makeWrapper
    shared-mime-info
  ];

  dontWrapQtApps = true;

  buildInputs = [
    libGLU
    lz4
    e2fsprogs
    gnutls
    gtk3
    nghttp2
    libpsl
    libsForQt5.qtbase
    libsForQt5.qt5.qtwayland
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp -r usr $out
    cp -r usr/share $out/share

    mimetypeDir=$out/share/icons/hicolor/128x128/mimetypes
    mkdir -p ''$mimetypeDir
    for file in usr/share/ideamaker/icons/*.ico; do
      mv $file ''$mimetypeDir/''$(basename ''${file%.ico}).png
    done
    install -D ${./mimetypes.xml} \
      $out/share/mime/packages/ideamaker.xml

    install -D usr/share/ideamaker/icons/ideamaker-icon.png \
      $out/share/pixmaps/ideamaker.png

    ln -sf $out/usr/lib/x86_64-linux-gnu/ideamaker/ideamaker $out/bin/ideamaker

    runHook postInstall
  '';

  preFixup = ''
    wrapProgram $out/bin/ideamaker \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set QT_XKB_CONFIG_ROOT "${xkeyboardconfig}/share/X11/xkb" \
      --set QTCOMPOSE "${libX11.out}/share/X11/locale" \
      --set KDEDIRS "$HOME/.nix-profile:/nix/var/nix/profiles/default" \
      --set NIX_REDIRECTS /usr/share=$out/share/
  '';

  postFixup = ''
    patchelf \
      --add-needed libdbus-1.so.3 \
      "$out/usr/lib/x86_64-linux-gnu/ideamaker/libQt5DBus.so.5.15.2"
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
    changelog = "https://www.raise3d.com/download/ideamaker-release-notes/";
    homepage = "https://www.raise3d.com/ideamaker/";
    license = lib.licenses.unfree;
    mainProgram = "ideamaker";
    maintainers = with lib.maintainers; [ cjshearer ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
