{ stdenv, lib, fetchurl,
  dpkg,
  alsaLib,
  at-spi2-atk,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk_pixbuf,
  glib,
  gnome2,
  gtk3,
  libuuid,
  libX11,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXScrnSaver,
  libXtst,
  nspr,
  nss,
  pango,
  udev,
  xorg,
  zlib
}:

let rpath = lib.makeLibraryPath [
    alsaLib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gnome2.GConf
    gtk3
    libuuid
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXScrnSaver
    libXtst
    nspr
    nss
    pango
    udev
    xorg.libxcb
    zlib
];


in stdenv.mkDerivation rec {
    name = "brave";
    version = "0.25.2";

    src = fetchurl {
        url = "https://github.com/brave/browser-laptop/releases/download/v${version}dev/brave_${version}_amd64.deb";
        sha256 = "1r3rsa6szps7mvvpqyw0mg16zn36x451dxq4nmn2l5ds5cp1f017";
    };

    phases = [ "unpackPhase" "installPhase" ];

    nativeBuildInputs = [ dpkg ];

    unpackPhase = "dpkg-deb -x $src .";

    installPhase = ''
        mkdir -p $out

        cp -R usr/* $out

        patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "${rpath}" $out/bin/brave
    '';

    meta = with stdenv.lib; {
        homepage = "https://brave.com/";
        description = "Privacy-oriented browser for Desktop and Laptop computers";
        longDescription = ''
          Brave browser blocks the ads and trackers that slow you down,
          chew up your bandwidth, and invade your privacy. Brave lets you
          contribute to your favorite creators automatically.
        '';
        license = licenses.mpl20;
        maintainers = [ maintainers.uskudnik ];
        platforms = [ "x86_64-linux" ];
    };
}
