{
  stdenv,
  fetchzip,
  lib,
  libarchive,
  makeWrapper,
  autoPatchelfHook,
  libxkbcommon,
  libxcb-cursor,
  libxcb-wm,
  libxcb-util,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  krb5,
  brotli,
  fontconfig,
  freetype,
  gtk3,
  pango,
  at-spi2-atk,
  unixodbc,
  firebird,
  libdrm,
  openldap,
  bash,
  kdePackages,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "amnezia-vpn-bin";
  version = "4.8.15.4";

  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/amnezia-vpn/amnezia-client/releases/download/${finalAttrs.version}/AmneziaVPN_${finalAttrs.version}_linux_x64.tar";
    hash = "sha256-Dr8zuzgwMAPXOTh69URFvA7EzGMnfBFO6kPhjhtjr6A=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    libarchive
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc
    bash
    libxkbcommon
    libxcb-cursor
    libxcb-wm
    libxcb-util
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    krb5.lib
    brotli.lib
    fontconfig.lib
    freetype
    gtk3
    pango
    at-spi2-atk
    unixodbc
    firebird
    libdrm
    openldap
    kdePackages.wayland
  ];

  # These libraries are not available in nixpkgs. They are Oracle Instant Client
  # (libclntsh.so.23.1) and UCanAccess/Mimer SQL (libmimerapi.so) drivers that
  # are bundled with Qt's SQlite database plugins (libqsqlora, libqsqlmimer).
  # The Amnezia VPN binary ships pre-linked against these Qt database drivers
  # even though it does not use them. Without ignoring these missing deps,
  # autoPatchelfHook would fail the build.
  autoPatchelfIgnoreMissingDeps = [
    "libclntsh.so.23.1"
    "libmimerapi.so"
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/amnezia-vpn $out/bin $out/share/applications $out/lib/systemd/system $out/share/icons/hicolor/512x512/apps

    bsdtar -xf AmneziaVPN_Linux_Installer.bin -C $out/share/amnezia-vpn

    makeWrapper "$out/share/amnezia-vpn/client/bin/AmneziaVPN" "$out/bin/AmneziaVPN" \
      --prefix LD_LIBRARY_PATH : "$out/share/amnezia-vpn/client/lib" \
      --set QML_IMPORT_PATH "$out/share/amnezia-vpn/client/qml" \
      --set QML2_IMPORT_PATH "$out/share/amnezia-vpn/client/qml" \
      --set QT_PLUGIN_PATH "$out/share/amnezia-vpn/client/plugins" \
      --set QT_QPA_PLATFORM_PLUGIN_PATH "$out/share/amnezia-vpn/client/plugins/platforms" \
      --set QTDIR "$out/share/amnezia-vpn/client" \
      --set CQT_PKG_ROOT "$out/share/amnezia-vpn/client"

    makeWrapper "$out/share/amnezia-vpn/service/bin/AmneziaVPN-service" "$out/bin/AmneziaVPN-service" \
      --prefix LD_LIBRARY_PATH : "$out/share/amnezia-vpn/client/lib" \
      --prefix LD_LIBRARY_PATH : "$out/share/amnezia-vpn/service/lib" \
      --set QML_IMPORT_PATH "$out/share/amnezia-vpn/service/qml" \
      --set QML2_IMPORT_PATH "$out/share/amnezia-vpn/service/qml" \
      --set QT_PLUGIN_PATH "$out/share/amnezia-vpn/service/plugins" \
      --set QT_QPA_PLATFORM_PLUGIN_PATH "$out/share/amnezia-vpn/service/plugins/platforms" \
      --set QTDIR "$out/share/amnezia-vpn/service" \
      --set CQT_PKG_ROOT "$out/share/amnezia-vpn/service"

    substituteInPlace $out/share/amnezia-vpn/AmneziaVPN.service \
      --replace-fail "/opt/AmneziaVPN/service/AmneziaVPN-service.sh" "AmneziaVPN-service" \
      --replace-fail "Environment=LD_LIBRARY_PATH=/opt/AmneziaVPN/client/lib" ""
    ln -s $out/share/amnezia-vpn/AmneziaVPN.service $out/lib/systemd/system/AmneziaVPN.service

    substituteInPlace $out/share/amnezia-vpn/AmneziaVPN.desktop \
      --replace-fail "/usr/share/pixmaps/AmneziaVPN.png" "AmneziaVPN"
    ln -s $out/share/amnezia-vpn/AmneziaVPN.desktop $out/share/applications/AmneziaVPN.desktop

    ln -s $out/share/amnezia-vpn/AmneziaVPN.png $out/share/icons/hicolor/512x512/apps/AmneziaVPN.png

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Amnezia VPN Client (binary release)";
    downloadPage = "https://amnezia.org/en/downloads";
    homepage = "https://github.com/amnezia-vpn/amnezia-client";
    license = lib.licenses.gpl3;
    mainProgram = "AmneziaVPN";
    maintainers = with lib.maintainers; [ sund3RRR ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
