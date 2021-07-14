{ autoPatchelfHook, makeDesktopItem, lib, stdenv, wrapGAppsHook
, alsa-lib, at-spi2-atk, at-spi2-core, atk, cairo, cups, dbus, expat, fontconfig
, freetype, gdk-pixbuf, glib, gtk3, libcxx, libdrm, libnotify, libpulseaudio, libuuid
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb, libxshmfence
, mesa, nspr, nss, pango, systemd, libappindicator-gtk3, libdbusmenu
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "aether";
  version = "2.0.0-dev15";
  binaryName = "AetherP2P";
  desktopName = "Aether";

  src = fetchurl {
    url = "https://static.getaether.net/Releases/Aether-2.0.0-dev.15/2011262249.19338c93/linux/Aether-2.0.0-dev.15%2B2011262249.19338c93.tar.gz";
    sha256 = "1hi8w83zal3ciyzg2m62shkbyh6hj7gwsidg3dn88mhfy68himf7";
    name = "aether-tarball.tar.gz";
  };

  dontWrapGApps = true;

  nativeBuildInputs = [
    alsa-lib
    autoPatchelfHook
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
    wrapGAppsHook
  ];

  libPath = lib.makeLibraryPath [
    libcxx systemd libpulseaudio libdrm mesa
    stdenv.cc.cc alsa-lib atk at-spi2-atk at-spi2-core cairo cups dbus expat fontconfig freetype
    gdk-pixbuf glib gtk3 libnotify libX11 libXcomposite libuuid
    libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
    libXtst nspr nss libxcb pango systemd libXScrnSaver
    libappindicator-gtk3 libdbusmenu
  ];

  installPhase = ''
    mkdir -p $out/{bin,opt/${binaryName},share/pixmaps}
    mv * $out/opt/${binaryName}

    chmod +x $out/opt/${binaryName}/${binaryName}
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
        $out/opt/${binaryName}/${binaryName}

    wrapProgram $out/opt/${binaryName}/${binaryName} \
        "''${gappsWrapperArgs[@]}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
        --prefix LD_LIBRARY_PATH : ${libPath}

    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/
    # Without || true the install would fail on case-insensitive filesystems
    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/${lib.strings.toLower binaryName} || true
    ln -s $out/opt/${binaryName}/aether.png $out/share/pixmaps/${pname}.png

    ln -s "${desktopItem}/share/applications" $out/share/
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = binaryName;
    icon = pname;
    inherit desktopName;
    genericName = meta.description;
    categories = "Network;";
    mimeType = "x-scheme-handler/aether";
  };

  meta = with lib; {
    description = "Peer-to-peer ephemeral public communities";
    homepage = "https://getaether.net/";
    downloadPage = "https://getaether.net/download/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ maxhille ];
    # other platforms could be supported by building from source
    platforms = [ "x86_64-linux" ];
  };
}
