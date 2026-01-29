{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  kdePackages,
  gtk3,
  atk,
  cairo,
  gdk-pixbuf,
  pango,
  openssl,
  icu,
  mysql80,
  libdrm,
  autoPatchelfHook,
  patchelf,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freedownloadmanager";
  version = "6.26.1.6177";

  src = fetchurl {
    url = "http://debrepo.freedownloadmanager.org/pool/main/f/freedownloadmanager/freedownloadmanager_${finalAttrs.version}_amd64.deb";
    hash = "sha256-yjyRB/4vnVXB8ZmicZxsrENCCUtp7bRR0YY5x0JtmTg=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    patchelf
    kdePackages.wrapQtAppsHook
    desktop-file-utils
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtmultimedia
    kdePackages.qtwayland
    kdePackages.qt5compat

    gtk3
    atk
    cairo
    gdk-pixbuf
    pango

    openssl
    icu
    mysql80
    libdrm
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt $out/share/applications $out/share/pixmaps

    cp -r opt/freedownloadmanager $out/opt/
    cp -r usr/share/applications/* $out/share/applications/

    ln -s $out/opt/freedownloadmanager/fdm $out/bin/fdm
    ln -s $out/opt/freedownloadmanager/icon.png $out/share/pixmaps/freedownloadmanager.png

    local desktopFile="$out/share/applications/freedownloadmanager.desktop"

    desktop-file-edit \
      --set-key=Exec --set-value=fdm \
      --set-key=Icon --set-value=freedownloadmanager \
      "$desktopFile"

    local sql_plugin_dir="$out/opt/freedownloadmanager/plugins/sqldrivers"
    if [ -f "$sql_plugin_dir/libqsqlmimer.so" ]; then
      patchelf --remove-needed libmimerapi.so "$sql_plugin_dir/libqsqlmimer.so" || echo "Warning: Failed to patch libqsqlmimer.so"
    fi

    if [ ! -f "$sql_plugin_dir/libqsqlmysql.so" ]; then
      echo "Warning: MySQL plugin libqsqlmysql.so not found."
    fi

    runHook postInstall
  '';

  preFixup = ''
    local lib_dir="$out/opt/freedownloadmanager/lib"
    rm -vf $lib_dir/libQt6*.so.6
    rm -vf $lib_dir/libicu*.so.*
    rm -vf $lib_dir/libcrypto.so*
    rm -vf $lib_dir/libssl.so*
  '';

  meta = {
    description = "Download manager supporting many protocols";
    homepage = "https://www.freedownloadmanager.org";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ scriptod ];
    mainProgram = "fdm";
  };
})
