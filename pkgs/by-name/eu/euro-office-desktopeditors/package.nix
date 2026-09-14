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
  libnotify,
  libpulseaudio,
  libudev0-shim,
  libdrm,
  makeWrapper,
  libgbm,
  noto-fonts-cjk-sans,
  nspr,
  nss,
  pulseaudio,
  qt6,
  wrapGAppsHook3,
  xkeyboard_config,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libxcb,

  unzip,
  libxcb-cursor,
  libmysqlclient,
  libGL,
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
    pname = "euro-office-desktopeditors";
    version = "9.4.0";

    #src = fetchurl {
    #  url = "https://github.com/Euro-Office/DesktopEditors/actions/runs/28295624289/artifacts/7926798036";
    #  hash = "";
    #};
    src = /home/onny/Downloads/linux-packages-amd64.zip;

    unpackPhase = ''
      mkdir -p source
      cd source
      unzip $src
      dpkg-deb -x euro-office-desktopeditors_*.deb .
    '';

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
      wrapGAppsHook3
      unzip
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
      libnotify
      libpulseaudio
      libdrm
      nspr
      nss
      libgbm
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtsvg
      qt6.qtwayland
      qt6.qtquick3d
      libx11
      libxcb
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxscrnsaver
      libxtst

      libxcb-cursor
      libmysqlclient
    ];

    dontWrapQtApps = true;

    dontStrip = 1;

autoPatchelfIgnoreMissingDeps = [
  "libmysqlclient.so.21"
  "libclntsh.so.23.1"
  "libfbclient.so.2"
  "libmimerapi.so"
];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib,share}

      mv usr/bin/* $out/bin
      mv usr/share/* $out/share/
      mv opt/euro-office/desktopeditors $out/share

      for f in $out/share/desktopeditors/asc-de-*.png; do
        size=$(basename "$f" ".png" | cut -d"-" -f3)
        res="''${size}x''${size}"
        mkdir -pv "$out/share/icons/hicolor/$res/apps"
        ln -s "$f" "$out/share/icons/hicolor/$res/apps/euro-office-desktopeditors.png"
      done;

      substituteInPlace $out/bin/euro-office-desktopeditors \
        --replace-fail "/opt/euro-office/" "$out/share/"

      ln -s $out/share/desktopeditors/DesktopEditors $out/bin/DesktopEditors

      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "/usr/lib:usr/lib32:${runtimeLibs}" \
        --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
        --set QTCOMPOSE "${libx11.out}/share/X11/locale" \
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
    libGL
  ];

  runScript = "/bin/euro-office-desktopeditors";

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${derivation}/share/icons $out/share
    cp -r ${derivation}/share/applications $out/share
    substituteInPlace $out/share/applications/euro-office-desktopeditors.desktop \
        --replace-fail "/usr/bin/euro-office-desktopeditors" "$out/bin/euro-office-desktopeditors"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Office suite that combines text, spreadsheet and presentation editors allowing to create, view and edit local documents";
    homepage = "https://www.onlyoffice.com/";
    downloadPage = "https://github.com/ONLYOFFICE/DesktopEditors/releases";
    changelog = "https://github.com/ONLYOFFICE/DesktopEditors/blob/master/CHANGELOG.md";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ onny ];
  };
}
