{ lib
, stdenv
, fetchurl
, wrapGAppsHook
, autoPatchelfHook
, makeDesktopItem
, atk
, cairo
, coreutils
, curl
, cups
, dbus-glib
, dbus
, dconf
, fontconfig
, freetype
, gdk-pixbuf
, glib
, glibc
, gtk3
, libX11
, libXScrnSaver
, libxcb
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXinerama
, libXrender
, libXt
, libnotify
, gnome
, libGLU
, libGL
, nspr
, nss
, pango
, gsettings-desktop-schemas
, alsa-lib
, libXtst
}:

stdenv.mkDerivation rec {
  pname = "zotero";
  version = "7.0.0-beta";

  src = fetchurl {
    url = "https://download.zotero.org/client/beta/${version}.51%2B7c5600913/Zotero-${version}.51%2B7c5600913_linux-x86_64.tar.bz2";
    hash = "sha256-zJ+jG7zlvWq+WEYOPyMIhqHPfsUe9tn0cbRyibQ7bFw=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
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
    categories = [ "Office" "Database" ];
    startupNotify = true;
    mimeTypes = [ "x-scheme-handler/zotero" "text/plain" ];
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
    for size in 16 32 48 256; do
      install -Dm444 chrome/icons/default/default$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
    done

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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ atila ];
  };
}
