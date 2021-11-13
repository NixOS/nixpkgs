{ alsa-lib, at-spi2-atk, at-spi2-core, atk, autoPatchelfHook, cairo, cups
, dbus, electron_9, expat, fetchurl, gdk-pixbuf, glib, gtk3, lib
, libappindicator-gtk3, libdbusmenu-gtk3, libuuid, makeWrapper
, nspr, nss, pango, squashfsTools, stdenv, systemd, xorg
}:

let
  # Currently only works with electron 9
  electron = electron_9;
in

stdenv.mkDerivation rec {
  pname = "authy";
  version = "1.9.0";
  rev = "7";

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
    libuuid
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
    sha256 = "10az47cc3lgsdi0ixmmna08nqf9xm7gsl1ph00wfwrxzsi05ygx3";
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

    mkdir -p $out/lib/

    cp -r ./* $out/
    rm -R ./*

    # The snap package has the `ffmpeg.so` file which is copied over with other .so files
    mv $out/*.so $out/lib/

    # Replace icon name in Desktop file
    sed -i 's|''${SNAP}/meta/gui/icon.png|authy|g' "$out/meta/gui/authy.desktop"

    # Move the desktop file, icon, binary to their appropriate locations
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps/apps
    cp $out/meta/gui/authy.desktop $out/share/applications/
    cp $out/meta/gui/icon.png $out/share/pixmaps/authy.png
    cp $out/${pname} $out/bin/${pname}

    # Cleanup
    rm -r $out/{data-dir,gnome-platform,meta,scripts,usr,*.sh,*.so}

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
