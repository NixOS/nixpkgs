{ lib, stdenv, autoPatchelfHook, makeDesktopItem, copyDesktopItems, wrapGAppsHook, fetchurl
, alsa-lib, at-spi2-atk, at-spi2-core, atk, cairo, cups
, gtk3, nss, glib, dbus, nspr, gdk-pixbuf
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb, pango
, gcc-unwrapped, udev
}:

stdenv.mkDerivation rec {
  pname = "snapmaker-luban";
  version = "4.1.4";

  src = fetchurl {
    url = "https://github.com/Snapmaker/Luban/releases/download/v${version}/snapmaker-luban-${version}-linux-x64.tar.gz";
    sha256 = "sha256-hbqIwX6YCrUQAjvKKWFAUjHvcZycnIA6v6l6qmAMuUI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    gcc-unwrapped
    gtk3
    libXdamage
    libX11
    libXScrnSaver
    libXtst
    libxcb
    nspr
    nss
  ];

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc alsa-lib atk at-spi2-atk at-spi2-core cairo cups
    gdk-pixbuf glib gtk3 libX11 libXcomposite
    libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
    libXtst nspr nss libxcb pango libXScrnSaver udev
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt,share/pixmaps}/
    mv * $out/opt/

    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      $out/opt/snapmaker-luban

    wrapProgram $out/opt/snapmaker-luban \
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --prefix LD_LIBRARY_PATH : ${libPath}:$out/snapmaker-luban

    ln -s $out/opt/snapmaker-luban $out/bin/snapmaker-luban
    ln -s $out/opt/resources/app/app/resources/images/snap-luban-logo-64x64.png $out/share/pixmaps/snapmaker-luban.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "snapmaker-luban";
      icon = "snapmaker-luban";
      desktopName = "Snapmaker Luban";
      genericName = meta.description;
      categories = [ "Office" "Printing" ];
    })
  ];

  meta = with lib; {
    description = "Snapmaker Luban is an easy-to-use 3-in-1 software tailor-made for Snapmaker machines";
    homepage = "https://github.com/Snapmaker/Luban";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3;
    maintainers = [ maintainers.simonkampe ];
    platforms = [ "x86_64-linux" ];
  };
}
