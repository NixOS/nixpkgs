{
  stdenv,
  lib,
  fetchurl,
  buildFHSEnv,
  unzip,
  patchelfUnstable,
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
  firebird,
  fontconfig,
  gcc-unwrapped,
  gdk-pixbuf,
  glib,
  glibc,
  gsettings-desktop-schemas,
  gst_all_1,
  gtk2,
  gtk3,
  libGL,
  libdrm,
  libgbm,
  libmysqlclient,
  libnotify,
  libpulseaudio,
  libudev0-shim,
  libx11,
  libxcb,
  libxcb-cursor,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxtst,
  makeWrapper,
  noto-fonts-cjk-sans,
  nspr,
  nss,
  pulseaudio,
  qt6,
  wrapGAppsHook3,
  xkeyboard_config,
}:
let

  # Note on fonts:
  #
  # EuroOffice does not distribute unfree fonts, but makes it easy to pick up
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

  derivation = stdenv.mkDerivation (finalAttrs: {
    pname = "euro-office-desktopeditors";
    # No release yet, pinning to latest version where Linux artifacts
    # where provided.
    version = "9.3.1-dev.1";
    # Manual uploaded Github CI artifact (actions run 28295624289,
    # artifact 7926798036) of linux-packages-amd64 tarball.
    src = fetchurl {
      url = "https://archive.org/download/euro-office-desktopeditors-9.3.1-dev.1-linux-amd64/linux-packages-amd64.zip";
      hash = "sha256-OV3abn9nYq/FeBkpft+27iGt34Rqi2VkJkAZwBHu1lM=";
    };

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
      patchelfUnstable
      unzip
      wrapGAppsHook3
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      atk
      cairo
      dbus
      dconf
      firebird
      fontconfig
      gdk-pixbuf
      glib
      gsettings-desktop-schemas
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
      gtk2
      gtk3
      libdrm
      libgbm
      libmysqlclient
      libnotify
      libpulseaudio
      libx11
      libxcb
      libxcb-cursor
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
      nspr
      nss
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtquick3d
      qt6.qtsvg
      qt6.qtwayland
    ];

    dontWrapQtApps = true;

    dontStrip = 1;

    autoPatchelfIgnoreMissingDeps = [
      # 'mysql80' reached end of life on 2026-04-30 and has been removed.
      "libmysqlclient.so.21"
      # These libraries are not available in nixpkgs. They are Oracle Instant Client
      # (libclntsh.so.23.1) and UCanAccess/Mimer SQL (libmimerapi.so) drivers that
      # are bundled with Qt's SQlite database plugins (libqsqlora, libqsqlmimer).
      "libclntsh.so.23.1"
      "libmimerapi.so"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib,share}

      mv usr/bin/* $out/bin
      mv usr/share/* $out/share/
      mv opt/euro-office/desktopeditors $out/share

      substituteInPlace $out/bin/euro-office-desktopeditors \
        --replace-fail "/opt/euro-office/" "$out/share/"

      ln -s $out/share/desktopeditors/DesktopEditors $out/bin/DesktopEditors

      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
        --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
        --set QTCOMPOSE "${libx11.out}/share/X11/locale" \
        --set QT_QPA_PLATFORM "xcb"
        # the bundled version of qt does not support wayland
      )
    '';
  });

in

# In order to download plugins, Euro-Office uses /usr/bin/curl so we have to wrap it.
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

  meta = {
    description = "Office suite that combines text, spreadsheet and presentation editors allowing to create, view and edit local documents";
    homepage = "https://github.com/Euro-Office/DesktopEditors";
    downloadPage = "https://github.com/Euro-Office/DesktopEditors/releases";
    changelog = "https://github.com/Euro-Office/DesktopEditors/blob/v9.3.1/CHANGELOG.md";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "euro-office-desktopeditors";
  };
}
