{ appimageTools
, fetchurl
, lib
}:

# You can debug this package with: $ ELECTRON_ENABLE_LOGGING=true timedoctor
let
  version = "3.12.12";
  sha256 = "01j149c6lacgysll3sajxlb43m1al08kdcwc6zyzw80nrp4iagf6";
in
appimageTools.wrapType2 {
  name = "timedoctor-${version}";
  src = fetchurl {
    inherit sha256;
    url = "https://repo2.timedoctor.com/td-desktop-hybrid/prod/v${version}/timedoctor-desktop_${version}_linux-x86_64.AppImage";
  };
  multiPkgs = _: with _; [
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    coreutils
    cups
    dbus
    dbus.lib
    desktop-file-utils
    expat
    expat.dev
    file
    freetype
    gcc
    gcc-unwrapped.lib
    gdb
    gdk-pixbuf
    git
    glib
    glibc
    gdk-pixbuf
    gtk3
    gtk3.dev
    gnome.zenity
    gnome2.GConf
    gnumake
    gnutar
    gpsd
    gtk3
    gtk3.dev
    gtk3-x11
    gtk3-x11.dev
    plasma5Packages.kdialog
    libappindicator-gtk2.out
    libexif
    (libjpeg.override { enableJpeg8 = true; }).out
    libnotify
    libpng
    libxml2
    libxslt
    netcat
    nettools
    nodePackages.asar
    nspr
    nss
    openjdk
    pango
    patchelf
    python38
    strace
    sqlite
    sqlite.dev
    udev
    unzip
    util-linux
    watch
    wget
    which
    wrapGAppsHook
    xdg-utils
    xorg.libX11
    xorg.libXau
    xorg.libXaw
    xorg.libXaw3d
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXdmcp
    xorg.libXext
    xorg.libXfixes
    xorg.libXfont
    xorg.libXfont2
    xorg.libXft
    xorg.libXi
    xorg.libXinerama
    xorg.libXmu
    xorg.libXp
    xorg.libXpm
    xorg.libXpresent
    xorg.libXrandr
    xorg.libXrender
    xorg.libXres
    xorg.libXScrnSaver
    xorg.libXt
    xorg.libXTrap
    xorg.libXtst
    xorg.libXv
    xorg.libXvMC
    xorg.libXxf86dga
    xorg.libXxf86misc
    xorg.libXxf86vm
    xorg.xcbutilkeysyms
    zip
    zlib
    zsh
  ];
  meta = with lib; {
    description = "Employee time tracking software";
    homepage = "https://www.timedoctor.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ dsalaza4 ];
    platforms = [ "x86_64-linux" ];
    # gpgme for i686-linux failed to build.
    broken = true;
  };
}
