{ pkgs ? import <nixpkgs> {} }:

let mailspring-deb = pkgs.stdenv.mkDerivation rec {
  name = "mailspring-deb";
  version = "1.6.3";
  src = pkgs.fetchurl {
    url = "https://github.com/Foundry376/Mailspring/releases/download/${version}/mailspring-${version}-amd64.deb";
    sha256 = "0lahvfvxwqbnp12qqc6pzbv5vnr3fr9i11af8lqrdjsd1ylsb73r";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildCommand = ''
    mkdir -p $out

    ${pkgs.dpkg}/bin/dpkg-deb -x $src unpacked

    LIBS=/usr/share/mailspring/resources/app.asar.unpacked
    cd "unpacked$LIBS"
    cat <<EOF > mailsync
    #!/bin/bash
    set -e
    set -o pipefail
    SASL_PATH="$LIBS" LD_LIBRARY_PATH="$LIBS:/usr/lib:/usr/lib32" $LIBS/mailsync.bin "\$@"
    EOF
    cd -
    mv unpacked/usr/* $out/
  '';
};
in pkgs.buildFHSUserEnv {
  name = "mailspring";
  targetPkgs = pkgs: with pkgs; [
    libsecret
    libgnome-keyring
    git
    gnome2.GConf
    gnome3.adwaita-icon-theme
    gtk2
    gtk3
    libudev0-shim
    libgcrypt
    libnotify
    xorg.libXtst
    nss
    python
    gvfs
    xdg_utils

    alsaLib
    cups
    dbus
    glib
    nspr
    pango
    atk
    at_spi2_atk
    cairo
    gdk-pixbuf
    expat
    libuuid

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
    xorg.libxkbfile

    mailspring-deb
  ];
  multiPkgs = pkgs: [];
  profile = ''
    export XDG_DATA_DIRS="$(printf "%s:" /usr/share/gsettings-schemas/*)$XDG_DATA_DIRS"
  '';
  runScript = "mailspring";

  meta = with pkgs.stdenv.lib; {
    description = "A beautiful, fast and maintained fork of Nylas Mail by one of the original authors";
    longDescription = ''
      Mailspring is an open-source mail client forked from Nylas Mail and built with Electron.
      Mailspring's sync engine runs locally, but its source is not open.
    '';
    homepage = https://getmailspring.com/;
    platforms = [ "x86_64-linux" ];
  };
}
