{ fetchurl, lib, stdenv, squashfsTools, makeWrapper, c-ares, gtk3-x11,
glib, libevent, libdrm, libvpx, libxslt, libnotify,
libappindicator-gtk2, libappindicator-gtk3, atk, mesa, cups, systemd,
alsaLib, at-spi2-atk, at-spi2-core, gdk-pixbuf, gnome2, cairo, xorg,
ffmpeg, http-parser, nss, nspr, dbus, expat }:

let
  deps = [
    c-ares
    gtk3-x11
    glib
    libevent
    libdrm
    libvpx
    libxslt
    libnotify
    libappindicator-gtk2
    libappindicator-gtk3
    atk
    mesa
    cups
    systemd
    alsaLib
    at-spi2-atk
    at-spi2-core
    gdk-pixbuf
    gnome2.pango
    cairo
    xorg.libxcb
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libXrandr
    ffmpeg
    http-parser
    nss
    nspr
    dbus
    expat
    stdenv.cc.cc
  ];
  rev = "10";

in

stdenv.mkDerivation rec {
  pname = "hey-mail";
  version = "1.1.0";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/lfWUNpR7PrPGsDfuxIhVxbj0wZHoH7bK_${rev}.snap";
    sha256 = "4fbd1f4cca1bfe2bd0c57c5df187459f2ce53cf5fd66f8ea155de3b810bfc7ce";
  };

  nativeBuildInputs = [
    squashfsTools
    makeWrapper
  ];

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src"
    cd squashfs-root
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/share/applications/ $out/share/icons/
    mv ./* $out/

    ln -s $out/meta/snap.yaml $out/snap.yaml

    rpath="$out"

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $rpath $out/hey-mail

    librarypath="${lib.makeLibraryPath deps}"

    wrapProgram $out/hey-mail \
      --prefix LD_LIBRARY_PATH : "$librarypath" \
      --prefix PATH : $out/bin

    install -Dm755 $out/hey-mail $out/bin/hey-mail

    # fix icon line in the desktop file
    sed -i "s:^Icon=.*:Icon=hey-mail:" "$out/meta/gui/hey-mail.desktop"

    # desktop file
    cp "$out/meta/gui/hey-mail.desktop" "$out/share/applications/"

    # icon
    ln -s "$out/meta/gui/icon.png" "$out/share/icons/hey-mail.png"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://hey.com";
    description = "Read your e-mails on HEY Mail desktop app";
    license = licenses.unfree;
    maintainers = with maintainers; [ bartuka ];
    platforms = [ "x86_64-linux" ];
  };
}
