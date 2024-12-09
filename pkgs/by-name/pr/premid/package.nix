{ autoPatchelfHook, makeDesktopItem, lib, stdenv, wrapGAppsHook3, fetchurl, copyDesktopItems
, alsa-lib, at-spi2-atk, at-spi2-core, atk, cairo, cups, dbus, expat, fontconfig
, freetype, gdk-pixbuf, glib, gtk3, libcxx, libdrm, libnotify, libpulseaudio, libuuid
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb, libxshmfence
, mesa, nspr, nss, pango, systemd, libappindicator-gtk3, libdbusmenu
}:

stdenv.mkDerivation rec {
  pname = "premid";
  version = "2.3.4";

  src = fetchurl {
    url = "https://github.com/premid/Linux/releases/download/v${version}/${pname}.tar.gz";
    sha256 = "sha256-ime6SCxm+fhMR2wagv1RItqwLjPxvJnVziW3DZafP50=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    cups
    libdrm
    libuuid
    libXdamage
    libX11
    libXScrnSaver
    libXtst
    libxcb
    libxshmfence
    mesa
    nss
  ];

  dontWrapGApps = true;
  dontBuild = true;
  dontConfigure = true;

  libPath = lib.makeLibraryPath [
    libcxx systemd libpulseaudio libdrm mesa
    stdenv.cc.cc alsa-lib atk at-spi2-atk at-spi2-core cairo cups dbus expat fontconfig freetype
    gdk-pixbuf glib gtk3 libnotify libX11 libXcomposite libuuid
    libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
    libXtst nspr nss libxcb pango systemd libXScrnSaver
    libappindicator-gtk3 libdbusmenu
   ];

  installPhase = ''
    mkdir -p $out/{bin,opt/PreMiD,share/pixmaps}
    mv * $out/opt/PreMiD

    chmod +x $out/opt/PreMiD/${pname}
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
        $out/opt/PreMiD/${pname}

    wrapProgram $out/opt/PreMiD/${pname} \
        "''${gappsWrapperArgs[@]}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/${pname}

    ln -s $out/opt/PreMiD/${pname} $out/bin/
  '';

  # This is the icon used by the desktop file
  postInstall = ''
    ln -s $out/opt/PreMiD/assets/appIcon.png $out/share/pixmaps/${pname}.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "PreMiD";
      icon = pname;
      desktopName = "PreMiD";
      genericName = meta.description;
      mimeTypes = [ "x-scheme-handler/premid" ];
    })
  ];

  meta = with lib; {
    description = "A simple, configurable utility to show your web activity as playing status on Discord";
    homepage = "https://premid.app";
    downloadPage = "https://premid.app/downloads";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mpl20;
    maintainers = with maintainers; [ natto1784 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "premid";
  };
}
