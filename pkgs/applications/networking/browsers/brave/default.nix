{ stdenv, lib, fetchurl
, dpkg
, alsaLib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, fontconfig
, freetype
, gdk_pixbuf
, glib
, gnome2
, gnome3
, gtk3
, libuuid
, libX11
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXScrnSaver
, libXtst
, nspr
, nss
, pango
, udev
, xorg
, zlib
, xdg_utils
, wrapGAppsHook
}:

let rpath = lib.makeLibraryPath [
    alsaLib
    at-spi2-atk
    at-spi2-core
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
    libuuid
    nspr
    nss
    pango
    udev
    xdg_utils
    xorg.libxcb
    zlib
];


in stdenv.mkDerivation rec {
    pname = "brave";
    version = "0.58.21";

    src = fetchurl {
        url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
        sha256 = "0mml8zjpm8gjw3krppr57y4p10ky975v0s4wyyx7ixr1lzk2qp11";
    };

    dontConfigure = true;
    dontBuild = true;
    dontPatchELF = true;

    nativeBuildInputs = [ dpkg wrapGAppsHook ];

    buildInputs = [ glib gnome3.gsettings_desktop_schemas gnome3.defaultIconTheme ];

    unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

    installPhase = ''
        mkdir -p $out $out/bin

        cp -R usr/share $out
        cp -R opt/ $out/opt

        export BINARYWRAPPER=$out/opt/brave.com/brave/brave-browser

        # Fix path to bash in $BINARYWRAPPER
        substituteInPlace $BINARYWRAPPER \
            --replace /bin/bash ${stdenv.shell}

        ln -sf $BINARYWRAPPER $out/bin/brave

        patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "${rpath}" $out/opt/brave.com/brave/brave

        # Fix paths
        substituteInPlace $out/share/applications/brave-browser.desktop \
            --replace /usr/bin/brave-browser $out/bin/brave
        substituteInPlace $out/share/gnome-control-center/default-apps/brave-browser.xml \
            --replace /opt/brave.com $out/opt/brave.com
        substituteInPlace $out/share/menu/brave-browser.menu \
            --replace /opt/brave.com $out/opt/brave.com
        substituteInPlace $out/opt/brave.com/brave/default-app-block \
            --replace /opt/brave.com $out/opt/brave.com

        # Correct icons location
        icon_sizes=("16" "22" "24" "32" "48" "64" "128" "256")

        for icon in ''${icon_sizes[*]}
        do
            mkdir -p $out/share/icons/hicolor/$icon\x$icon/apps
            ln -s $out/opt/brave.com/brave/product_logo_$icon.png $out/share/icons/hicolor/$icon\x$icon/apps/brave-browser.png
        done

        # Replace xdg-settings and xdg-mime
        ln -sf ${xdg_utils}/bin/xdg-settings $out/opt/brave.com/brave/xdg-settings
        ln -sf ${xdg_utils}/bin/xdg-mime $out/opt/brave.com/brave/xdg-mime
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
