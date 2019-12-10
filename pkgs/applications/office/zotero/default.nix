{ stdenv, fetchurl, wrapGAppsHook, makeDesktopItem
, atk
, cairo
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
, gnome3
, libGLU, libGL
, nspr
, nss
, pango
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "zotero";
  version = "5.0.80";

  src = fetchurl {
    url = "https://download.zotero.org/client/release/${version}/Zotero-${version}_linux-x86_64.tar.bz2";
    sha256 = "0a5xjliml6rwxvi450l42iw6m9mk3aahnp90sr22jyijz9qii2al";
  };

  buildInputs= [ wrapGAppsHook gsettings-desktop-schemas gtk3 gnome3.adwaita-icon-theme dconf ];

  phases = [ "unpackPhase" "patchPhase" "installPhase" "fixupPhase" ];

  dontStrip = true;
  dontPatchELF = true;

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.cc
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
      libGLU libGL
      nspr
      nss
      pango
    ] + ":" + stdenv.lib.makeSearchPathOutput "lib" "lib64" [
      stdenv.cc.cc
    ];

  patchPhase = ''
    sed -i '/pref("app.update.enabled", true);/c\pref("app.update.enabled", false);' defaults/preferences/prefs.js
  '';

  desktopItem = makeDesktopItem {
    name = "zotero-${version}";
    exec = "zotero -url %U";
    icon = "zotero";
    type = "Application";
    comment = meta.description;
    desktopName = "Zotero";
    genericName = "Reference Management";
    categories = "Office;Database;";
    startupNotify = "true";
    mimeType = "text/plain";
  };

  installPhase =
  ''
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

     for executable in \
       zotero-bin plugin-container \
       updater minidump-analyzer
     do
       if [ -e "$out/usr/lib/zotero-bin-${version}/$executable" ]; then
         patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
           "$out/usr/lib/zotero-bin-${version}/$executable"
       fi
     done
     find . -executable -type f -exec \
       patchelf --set-rpath "$libPath" \
         "$out/usr/lib/zotero-bin-${version}/{}" \;
  '';

  meta = with stdenv.lib; {
    homepage = https://www.zotero.org;
    description = "Collect, organize, cite, and share your research sources";
    license = licenses.agpl3;
    platforms = platforms.linux;
  };
}
