{ autoPatchelfHook, makeDesktopItem, lib, stdenv, wrapGAppsHook
, alsa-lib, at-spi2-atk, at-spi2-core, atk, cairo, cups, dbus, expat, fontconfig
, freetype, gdk-pixbuf, glib, gtk3, libcxx, libdrm, libnotify, libpulseaudio, libuuid
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb, libxshmfence
, mesa, nspr, nss, pango, systemd, libappindicator-gtk3, libdbusmenu
, fetchurl, fetchFromGitHub, imagemagick, copyDesktopItems
}:

let
  binaryName = "AetherP2P";
  aether-app-git = fetchFromGitHub {
    owner = "aethereans";
    repo = "aether-app";
    rev = "53b6c8b2a9253cbf056ea3ebb077e0e08cbc5b1d";
    sha256 = "1kgkzh7ih2q9dsckdkinh5dbzvr7gdykf8yz6h8pyhvzyjhk1v0r";
  };
in
stdenv.mkDerivation rec {
  pname = "aether";
  version = "2.0.0-dev.15";

  src = fetchurl {
    url = "https://static.getaether.net/Releases/Aether-${version}/2011262249.19338c93/linux/Aether-${version}%2B2011262249.19338c93.tar.gz";
    sha256 = "1hi8w83zal3ciyzg2m62shkbyh6hj7gwsidg3dn88mhfy68himf7";
    # % in the url / canonical filename causes an error
    name = "aether-tarball.tar.gz";
  };

  # there is no logo in the tarball so we grab it from github and convert it in the build phase
  buildPhase = ''
    convert ${aether-app-git}/aether-core/aether/client/src/app/ext_dep/images/Linux-Windows-App-Icon.png -resize 512x512 aether.png
  '';

  dontWrapGApps = true;

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

  nativeBuildInputs = [
    imagemagick
    autoPatchelfHook
    wrapGAppsHook
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = binaryName;
      icon = pname;
      desktopName = "Aether";
      genericName = meta.description;
      categories = [ "Network" ];
      mimeTypes = [ "x-scheme-handler/aether" ];
    })
  ];

  installPhase =
  let
    libPath = lib.makeLibraryPath [
      libcxx systemd libpulseaudio libdrm mesa
      stdenv.cc.cc alsa-lib atk at-spi2-atk at-spi2-core cairo cups dbus expat fontconfig freetype
      gdk-pixbuf glib gtk3 libnotify libX11 libXcomposite libuuid
      libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
      libXtst nspr nss libxcb pango systemd libXScrnSaver
      libappindicator-gtk3 libdbusmenu
    ];
  in
  ''
    mkdir -p $out/{bin,opt/${binaryName},share/icons/hicolor/512x512/apps}
    mv * $out/opt/${binaryName}

    chmod +x $out/opt/${binaryName}/${binaryName}
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
        $out/opt/${binaryName}/${binaryName}

    wrapProgram $out/opt/${binaryName}/${binaryName} \
        "''${gappsWrapperArgs[@]}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
        --prefix LD_LIBRARY_PATH : ${libPath}

    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/

    ln -s $out/opt/${binaryName}/aether.png $out/share/icons/hicolor/512x512/apps/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Peer-to-peer ephemeral public communities";
    homepage = "https://getaether.net/";
    downloadPage = "https://getaether.net/download/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ maxhille ];
    # other platforms could be supported by building from source
    platforms = [ "x86_64-linux" ];
  };
}
