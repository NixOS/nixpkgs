{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, flac
, gnome2
, harfbuzzFull
, nss
, snappy
, xdg-utils
, xorg
, alsa-lib
, atk
, cairo
, cups
, curl
, dbus
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, libX11
, libxcb
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libdrm
, libnotify
, libopus
, libpulseaudio
, libuuid
, libxshmfence
, mesa
, nspr
, pango
, systemd
, at-spi2-atk
, at-spi2-core
}:

stdenv.mkDerivation rec {
  pname = "yandex-browser";
  version = "22.1.3.907-1";

  src = fetchurl {
    url = "http://repo.yandex.ru/yandex-browser/deb/pool/main/y/${pname}-beta/${pname}-beta_${version}_amd64.deb";
    sha256 = "sha256-7dbFqNzZP2CyseK0xD9zcvecIuueZfMy5KgN8gRRLEk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    flac
    harfbuzzFull
    nss
    snappy
    xdg-utils
    xorg.libxkbfile
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig.lib
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gtk3
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
    libdrm
    libnotify
    libopus
    libuuid
    libxcb
    libxshmfence
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    mkdir $TMP/ya/ $out/bin/ -p
    ar vx $src
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/ya/
  '';

  installPhase = ''
    cp $TMP/ya/{usr/share,opt} $out/ -R
    substituteInPlace $out/share/applications/yandex-browser-beta.desktop --replace /usr/ $out/
    ln -sf $out/opt/yandex/browser-beta/yandex_browser $out/bin/yandex-browser
  '';

  runtimeDependencies = map lib.getLib [
    libpulseaudio
    curl
    systemd
  ] ++ buildInputs;

  meta = with lib; {
    description = "Yandex Web Browser";
    homepage = "https://browser.yandex.ru/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = [ "x86_64-linux" ];

    knownVulnerabilities = [
      ''
      Trusts a Russian government issued CA certificate for some websites.
      See https://habr.com/en/company/yandex/blog/655185/ (Russian) for details.
      ''
    ];
  };
}
