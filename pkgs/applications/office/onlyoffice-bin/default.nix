{ stdenv
, lib
, fetchurl
  # Alphabetic ordering below
, alsa-lib
, at-spi2-atk
, atk
, autoPatchelfHook
, cairo
, curl
, dbus
, dconf
, dpkg
, fontconfig
, gdk-pixbuf
, glib
, glibc
, gsettings-desktop-schemas
, gst_all_1
, gtk2
, gtk3
, libpulseaudio
, libudev0-shim
, libdrm
, makeWrapper
, nspr
, nss
, pulseaudio
, qt5
, wrapGAppsHook
, xkeyboard_config
, xorg
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

  # Not using the `noto-fonts-cjk` package from nixpkgs, because it was
  # reported that its `.ttc` file is not picked up by OnlyOffice, see:
  # https://github.com/NixOS/nixpkgs/pull/116343#discussion_r593979816
  noto-fonts-cjk = fetchurl {
    url =
      let
        version = "v20201206-cjk";
      in
      "https://github.com/googlefonts/noto-cjk/raw/${version}/NotoSansCJKsc-Regular.otf";
    sha256 = "sha256-aJXSVNJ+p6wMAislXUn4JQilLhimNSedbc9nAuPVxo4=";
  };

  runtimeLibs = lib.makeLibraryPath [
    curl
    glibc
    libudev0-shim
    pulseaudio
  ];

in
stdenv.mkDerivation rec {
  pname = "onlyoffice-desktopeditors";
  version = "7.1.0";
  minor = null;
  src = fetchurl {
    url = "https://github.com/ONLYOFFICE/DesktopEditors/releases/download/v${version}/onlyoffice-desktopeditors_amd64.deb";
    sha256 = "sha256-40IUAmg7PnfYrdTj7TVbfvb9ey0/zzswu+sJllAIktg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook
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
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtsvg
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

  preConfigure = ''
    cp --no-preserve=mode,ownership ${noto-fonts-cjk} opt/onlyoffice/desktopeditors/fonts/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,share}

    mv usr/bin/* $out/bin
    mv usr/share/* $out/share/
    mv opt/onlyoffice/desktopeditors $out/share

    substituteInPlace $out/bin/onlyoffice-desktopeditors \
      --replace "/opt/onlyoffice/" "$out/share/"

    ln -s $out/share/desktopeditors/DesktopEditors $out/bin/DesktopEditors

    substituteInPlace $out/share/applications/onlyoffice-desktopeditors.desktop \
      --replace "/usr/bin/onlyoffice-desktopeditor" "$out/bin/DesktopEditor"

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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Office suite that combines text, spreadsheet and presentation editors allowing to create, view and edit local documents";
    homepage = "https://www.onlyoffice.com/";
    downloadPage = "https://github.com/ONLYOFFICE/DesktopEditors/releases";
    changelog = "https://github.com/ONLYOFFICE/DesktopEditors/blob/master/CHANGELOG.md";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ nh2 gtrunsec ];
  };
}
