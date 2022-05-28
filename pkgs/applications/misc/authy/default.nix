{ alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, autoPatchelfHook
, cairo
, cups
, dbus
, electron
, expat
, fetchurl
, gdk-pixbuf
, glib
, gtk3
, lib
, libappindicator-gtk3
, libdbusmenu-gtk3
, libdrm
, libuuid
, makeWrapper
, mesa
, nspr
, nss
, pango
, squashfsTools
, stdenv
, systemd
, xorg
}:

stdenv.mkDerivation rec {
  pname = "authy";
  # curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/authy?channel=stable' | jq '.download_url,.version'
  version = "2.2.0";
  rev = "10";

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libappindicator-gtk3
    libdbusmenu-gtk3
    libdrm
    libuuid
    mesa # for libgbm
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
  ];

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/H8ZpNgIoPyvmkgxOWw5MSzsXK1wRZiHn_${rev}.snap";
    sha256 = "sha256-sB9/fVV/qp+DfjxpvzIUHsLkeEu35i2rEv1/JYMytG8=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper squashfsTools ];

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src"
    cd squashfs-root
    if ! grep -q '${version}' meta/snap.yaml; then
      echo "Package version differs from version found in snap metadata:"
      grep 'version: ' meta/snap.yaml
      echo "While the nix package specifies: ${version}."
      echo "You probably chose the wrong revision or forgot to update the nix version."
      exit 1
    fi
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/share/pixmaps/apps

    # Copy only what is needed
    cp -r resources* $out/
    cp -r locales* $out/
    cp meta/gui/authy.desktop $out/share/applications/
    cp meta/gui/icon.png $out/share/pixmaps/authy.png

    # Replace icon name in Desktop file
    sed -i 's|''${SNAP}/meta/gui/icon.png|authy|g' "$out/share/applications/authy.desktop"

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/resources/app.asar
  '';

  meta = with lib; {
    homepage = "https://www.authy.com";
    description = "Twilio Authy two factor authentication desktop application";
    license = licenses.unfree;
    maintainers = with maintainers; [ iammrinal0 ];
    platforms = [ "x86_64-linux" ];
  };
}
