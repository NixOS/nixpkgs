{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook3,
  autoPatchelfHook,
  makeDesktopItem,
  atk,
  cairo,
  coreutils,
  curl,
  cups,
  dbus-glib,
  dbus,
  dconf,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glibc,
  gtk3,
  libX11,
  libXScrnSaver,
  libxcb,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXinerama,
  libXrender,
  libXt,
  libnotify,
  gnome,
  libGLU,
  libGL,
  nspr,
  nss,
  pango,
  gsettings-desktop-schemas,
  alsa-lib,
  libXtst,
}:

stdenv.mkDerivation rec {
  pname = "zotero";
  version = "7.0.0-beta";

  src = fetchurl {
    url = "https://download.zotero.org/client/beta/${version}.65%2Bb047f3d90/Zotero-${version}.65%2Bb047f3d90_linux-x86_64.tar.bz2";
    hash = "sha256-e7T/hvb8bFb4hkouihBkgqUu4ugYoUMHNVKxh0r/WUM=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
  ];
  buildInputs = [
    gsettings-desktop-schemas
    glib
    gtk3
    gnome.adwaita-icon-theme
    dconf
    libXtst
    alsa-lib
    stdenv.cc.cc
    atk
    cairo
    curl
    cups
    dbus-glib
    dbus
    fontconfig
    freetype
    gdk-pixbuf
    glib
    glibc
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libxcb
    libXdamage
    libXext
    libXfixes
    libXi
    libXinerama
    libXrender
    libXt
    libnotify
    libGLU
    libGL
    nspr
    nss
    pango
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  desktopItem = makeDesktopItem {
    name = "zotero";
    exec = "zotero -url %U";
    icon = "zotero";
    comment = meta.description;
    desktopName = "Zotero";
    genericName = "Reference Management";
    categories = [
      "Office"
      "Database"
    ];
    startupNotify = true;
    mimeTypes = [
      "x-scheme-handler/zotero"
      "text/plain"
    ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$prefix/usr/lib/zotero-bin-${version}"
    cp -r * "$prefix/usr/lib/zotero-bin-${version}"
    mkdir -p "$out/bin"
    ln -s "$prefix/usr/lib/zotero-bin-${version}/zotero" "$out/bin/"

    # install desktop file and icons.
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/
    for size in 32 64 128; do
      install -Dm444 icons/icon$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
    done
    install -Dm444 icons/symbolic.svg \
        $out/share/icons/hicolor/symbolic/apps/zotero-symbolic.svg

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ coreutils ]}
    )
  '';

  meta = with lib; {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    mainProgram = "zotero";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ atila ];
  };
}
