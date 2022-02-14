{ stdenv
, lib
, fetchurl
, unzip
, dpkg
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gnome2
, gnome
, gsettings-desktop-schemas
, gtk3
, libpulseaudio
, libuuid
, libdrm
, libX11
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libxkbcommon
, libXrandr
, libXrender
, libXScrnSaver
, libxshmfence
, libXtst
, mesa
, nspr
, nss
, pango
, udev
, xorg
, zlib
, xdg-utils
, wrapGAppsHook
}:

let
  rpath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gtk3
    libdrm
    libpulseaudio
    libX11
    libxkbcommon
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
    libuuid
    mesa
    nspr
    nss
    pango
    udev
    xdg-utils
    xorg.libxcb
    zlib
  ];

in

stdenv.mkDerivation rec {
  pname = "decentr";
  version = "1.1.4";

  src = fetchurl {
    url = "https://decentr.net/files/Ubuntu_X64_Decentr_${version}.zip";
    sha256 = "sha256-Nl0/ML1taJQhjP4ldAYuB9Jv5zuVBX0blYAYkw0/vCA=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  doInstallCheck = true;

  nativeBuildInputs = [ unzip dpkg wrapGAppsHook ];

  buildInputs = [ glib gsettings-desktop-schemas gnome.adwaita-icon-theme ];

  unpackPhase = ''
    unzip -qq $src
    dpkg-deb --fsys-tarfile *.deb | tar -x --no-same-permissions --no-same-owner
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out $out/bin
    cp -R usr/share $out
    cp -R opt/ $out/opt
    export BINARYWRAPPER=$out/opt/decentr.org/decentr-unstable/decentr-browser-unstable
    # Fix path to bash in $BINARYWRAPPER
    substituteInPlace $BINARYWRAPPER \
        --replace /bin/bash ${stdenv.shell}
    ln -sf $BINARYWRAPPER $out/bin/decentr
    for exe in $out/opt/decentr.org/decentr-unstable/{decentr,chrome_crashpad_handler}; do
    patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${rpath}" $exe
    done
    # Fix paths
    substituteInPlace $out/share/applications/decentr-browser-unstable.desktop \
        --replace /usr/bin/decentr-browser-unstable $out/bin/decentr
    substituteInPlace $out/share/gnome-control-center/default-apps/decentr-browser-unstable.xml \
        --replace /opt/decentr.org $out/opt/decentr.org
    substituteInPlace $out/share/menu/decentr-browser-unstable.menu \
        --replace /opt/decentr.org $out/opt/decentr.org
    substituteInPlace $out/opt/decentr.org/decentr-unstable/default-app-block \
        --replace /opt/decentr.org $out/opt/decentr.org
    # Correct icons location
    icon_sizes=("16" "22" "24" "32" "48" "64" "128" "256")
    for icon in ''${icon_sizes[*]}
    do
        mkdir -p $out/share/icons/hicolor/$icon\x$icon/apps
        ln -s $out/opt/decentr.org/decentr-unstable/product_logo_$icon.png $out/share/icons/hicolor/$icon\x$icon/apps/decentr-browser.png
    done
    # Replace xdg-settings and xdg-mime
    ln -sf ${xdg-utils}/bin/xdg-settings $out/opt/decentr.org/decentr-unstable/xdg-settings
    ln -sf ${xdg-utils}/bin/xdg-mime $out/opt/decentr.org/decentr-unstable/xdg-mime
    runHook postInstall
  '';

  installCheckPhase = ''
    # Bypass upstream wrapper which suppresses errors
    $out/opt/decentr.org/decentr-unstable/decentr --version
  '';

  meta = with lib; {
    homepage = "https://decentr.org/";
    #  TODO: Refactor everything below. I copied this from Brave Browser's.
    description = "Browse to earn";
    maintainers = with maintainers; [ diogox ];
    platforms = [ "x86_64-linux" ];
  };
}
