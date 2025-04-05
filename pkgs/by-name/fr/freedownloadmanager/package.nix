{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  udev,
  libdrm,
  libpqxx,
  unixODBC,
  gst_all_1,
  libpulseaudio,
  xcbutilcursor,
  xcbutilwm,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  libxkbcommon,
  fontconfig,
  freetype,
  gtk3,
  pango,
  cairo,
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
    desktop-file-utils
  ];

  buildInputs =
    [
      libxkbcommon
      fontconfig
      gtk3
      pango
      freetype
      cairo
      libdrm
      libpqxx # Bundled Qt SQL plugin dependency (PostgreSQL)
      unixODBC # Bundled Qt SQL plugin dependency (ODBC)
      libpulseaudio # For QtMultimedia
      # XCB utils needed by Qt platform plugin
      xcbutilcursor
      xcbutilwm
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      udev
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-libav
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
    ]);

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt/ $out/opt
    cp -r usr/share $out/share
    ln -s $out/opt/freedownloadmanager/fdm $out/bin/fdm
    mkdir -p $out/share/pixmaps
    ln -s $out/opt/freedownloadmanager/icon.png $out/share/pixmaps/freedownloadmanager.png
    desktop-file-edit --set-key=Exec --set-value=fdm \
      --set-key=Icon --set-value=freedownloadmanager \
      $out/share/applications/freedownloadmanager.desktop
    patchelf --remove-needed libmimerapi.so $out/opt/freedownloadmanager/plugins/sqldrivers/libqsqlmimer.so || true
    patchelf --remove-needed libmysqlclient.so.21 $out/opt/freedownloadmanager/plugins/sqldrivers/libqsqlmysql.so || true

    runHook postInstall
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
