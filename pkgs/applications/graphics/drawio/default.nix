{ stdenv, lib, fetchurl, rpmextract, autoPatchelfHook, wrapGAppsHook

# Dynamic libraries
, alsa-lib, atk, at-spi2-atk, at-spi2-core, cairo, dbus, cups, expat
, gdk-pixbuf, glib, gtk3, libX11, libXScrnSaver, libXcomposite, libXcursor
, libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst
, libxcb, libuuid, libxshmfence, nspr, nss, pango, mesa

, systemd
}:

stdenv.mkDerivation rec {
  pname = "drawio";
  version = "20.6.2";

  src = fetchurl {
    url = "https://github.com/jgraph/drawio-desktop/releases/download/v${version}/drawio-x86_64-${version}.rpm";
    sha256 = "cf408c19622d7812b93f0f778b7f091a4387992f9d9a767f4bc1c417b61b7058";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    rpmextract
    wrapGAppsHook
  ];

  buildInputs = [
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
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
    libxshmfence
    libXtst
    libxcb
    libuuid
    mesa # for libgbm
    nspr
    nss
    pango
    systemd
  ];

  runtimeDependencies = [
    (lib.getLib systemd)
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = "rpmextract ${src}";

  installPhase = ''
    mkdir -p $out/share
    cp -r opt/drawio $out/share/

    # Application icon
    mkdir -p $out/share/icons/hicolor
    cp -r usr/share/icons/hicolor/* $out/share/icons/hicolor/

    # XDG desktop item
    cp -r usr/share/applications $out/share/applications

    # Symlink wrapper
    mkdir -p $out/bin
    ln -s $out/share/drawio/drawio $out/bin/drawio

    # Update binary path
    substituteInPlace $out/share/applications/drawio.desktop \
      --replace /opt/drawio/drawio $out/bin/drawio
  '';

  doInstallCheckPhase = true;

  installCheckPhase = ''
    $out/bin/drawio --help > /dev/null
  '';

  meta = with lib; {
    description = "A desktop application for creating diagrams";
    homepage = "https://about.draw.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    changelog = "https://github.com/jgraph/drawio-desktop/releases/tag/v${version}";
    maintainers = with maintainers; [ darkonion0 ];
    platforms = [ "x86_64-linux" ];
  };
}
