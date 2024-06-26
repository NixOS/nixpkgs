{
  stdenv,
  lib,
  fetchurl,
  buildFHSEnv,
  # Alphabetic ordering below
  alsa-lib,
  at-spi2-atk,
  atk,
  autoPatchelfHook,
  cairo,
  curl,
  dbus,
  dconf,
  dpkg,
  fontconfig,
  gcc-unwrapped,
  gdk-pixbuf,
  glib,
  glibc,
  gsettings-desktop-schemas,
  gst_all_1,
  gtk2,
  gtk3,
  libpulseaudio,
  libudev0-shim,
  libdrm,
  makeWrapper,
  mesa,
  noto-fonts-cjk-sans,
  nspr,
  nss,
  pulseaudio,
  qt5,
  wrapGAppsHook3,
  xkeyboard_config,
  xorg,
}:
let

  # Note on fonts:
  #
  # OnlyOffice does not distribute unfree fonts, but makes it easy to pick up
  # any fonts you install. See:
  #
  # * https://helpcenter.onlyoffice.com/en/installation/docs-community-install-fonts-linux.aspx
  # * https://www.onlyoffice.com/blog/2020/04/how-to-add-new-fonts-to-onlyoffice-desktop-editors/
  #
  # As recommended there, you should download
  #
  #     arial.ttf, calibri.ttf, cour.ttf, symbol.ttf, times.ttf, wingding.ttf
  #
  # into `~/.local/share/fonts/`, otherwise the default template fonts, and
  # things like bullet points, will not look as expected.

  # TODO: Find out which of these fonts we'd be allowed to distribute along
  #       with this package, or how to make this easier for users otherwise.

  runtimeLibs = lib.makeLibraryPath [
    curl
    glibc
    gcc-unwrapped.lib
    libudev0-shim
    pulseaudio
  ];

  derivation = stdenv.mkDerivation rec {
    pname = "onlyoffice-desktopeditors";
    version = "8.0.0";
    minor = null;
    src = fetchurl {
      url = "https://github.com/ONLYOFFICE/DesktopEditors/releases/download/v${version}/onlyoffice-desktopeditors_amd64.deb";
      sha256 = "sha256-YtR2fiARMKw8dOgAPXYM+WFwmhKZRsIIBQYTxppu3F0=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
      wrapGAppsHook3
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      atk
      cairo
      dbus
      dconf
      fontconfig
      gdk-pixbuf
      glib
      gsettings-desktop-schemas
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
      gtk2
      gtk3
      libpulseaudio
      libdrm
      nspr
      nss
      mesa # libgbm
      qt5.qtbase
      qt5.qtdeclarative
      qt5.qtsvg
      qt5.qtwayland
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXtst
    ];

    dontWrapQtApps = true;

    unpackPhase = ''
      dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib,share}

      mv usr/bin/* $out/bin
      mv usr/share/* $out/share/
      mv opt/onlyoffice/desktopeditors $out/share

      for f in $out/share/desktopeditors/asc-de-*.png; do
        size=$(basename "$f" ".png" | cut -d"-" -f3)
        res="''${size}x''${size}"
        mkdir -pv "$out/share/icons/hicolor/$res/apps"
        ln -s "$f" "$out/share/icons/hicolor/$res/apps/onlyoffice-desktopeditors.png"
      done;

      substituteInPlace $out/bin/onlyoffice-desktopeditors \
        --replace "/opt/onlyoffice/" "$out/share/"

      ln -s $out/share/desktopeditors/DesktopEditors $out/bin/DesktopEditors

      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
        --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
        --set QTCOMPOSE "${xorg.libX11.out}/share/X11/locale" \
        --set QT_QPA_PLATFORM "xcb"
        # the bundled version of qt does not support wayland
      )
    '';
  };

in

# In order to download plugins, OnlyOffice uses /usr/bin/curl so we have to wrap it.
# Curl still needs to be in runtimeLibs because the library is used directly in other parts of the code.
# Fonts are also discovered by looking in /usr/share/fonts, so adding fonts to targetPkgs will include them
buildFHSEnv {
  inherit (derivation) pname version;

  targetPkgs = pkgs': [
    curl
    derivation
    noto-fonts-cjk-sans
  ];

  runScript = "/bin/onlyoffice-desktopeditors";

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${derivation}/share/icons $out/share
    cp -r ${derivation}/share/applications $out/share
    substituteInPlace $out/share/applications/onlyoffice-desktopeditors.desktop \
        --replace "/usr/bin/onlyoffice-desktopeditors" "$out/bin/onlyoffice-desktopeditors"
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Office suite that combines text, spreadsheet and presentation editors allowing to create, view and edit local documents";
    mainProgram = "onlyoffice-desktopeditors";
    longDescription = ''
      This version is broken on wlroots environments (e.g. Hyprland, Sway).
      If you are using one of these environments, please use `onlyoffice-bin` instead.
    '';
    homepage = "https://www.onlyoffice.com/";
    downloadPage = "https://github.com/ONLYOFFICE/DesktopEditors/releases";
    changelog = "https://github.com/ONLYOFFICE/DesktopEditors/blob/master/CHANGELOG.md";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      nh2
      gtrunsec
    ];
  };
}
