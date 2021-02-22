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
, gdk-pixbuf
, glib
, gnome2
, gnome3
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
  pname = "brave";
  version = "1.19.88";

  src = fetchurl {
    url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
    sha256 = "jySedvm9V3O4kri1PgoqC0OsC1gvB0Nwx8leoUZnHK0=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  doInstallCheck = true;

  nativeBuildInputs = [ dpkg wrapGAppsHook ];

  buildInputs = [ glib gsettings-desktop-schemas gnome3.adwaita-icon-theme ];

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
          --replace /usr/bin/brave-browser-stable $out/bin/brave
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
      ln -sf ${xdg-utils}/bin/xdg-settings $out/opt/brave.com/brave/xdg-settings
      ln -sf ${xdg-utils}/bin/xdg-mime $out/opt/brave.com/brave/xdg-mime
  '';

  installCheckPhase = ''
    # Bypass upstream wrapper which suppresses errors
    $out/opt/brave.com/brave/brave --version
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://brave.com/";
    description = "Privacy-oriented browser for Desktop and Laptop computers";
    changelog = "https://github.com/brave/brave-browser/blob/v${version}/CHANGELOG.md";
    longDescription = ''
      Brave browser blocks the ads and trackers that slow you down,
      chew up your bandwidth, and invade your privacy. Brave lets you
      contribute to your favorite creators automatically.
    '';
    license = licenses.mpl20;
    maintainers = with maintainers; [ uskudnik rht jefflabonte nasirhm ];
    platforms = [ "x86_64-linux" ];
  };
}
