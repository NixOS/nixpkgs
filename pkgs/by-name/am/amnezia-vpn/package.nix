{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  cmake,
  pkg-config,
  kdePackages,
  qt6,
  libsecret,
  amneziawg-go,
  openvpn,
  shadowsocks-rust,
  cloak-pt,
  wireguard-tools,
  libssh,
  zlib,
  openssl,
  tun2socks,
  xray,
  nix-update-script,
  bash,
  callPackage,
}:
let
  amneziawg' = amneziawg-go.overrideAttrs (
    finalAttrs: prevAttrs: {
      name = "amneziawg-go";
      version = "0.2.16";

      src = fetchFromGitHub {
        owner = "amnezia-vpn";
        repo = "amneziawg-go";
        tag = "v${finalAttrs.version}";
        hash = "sha256-JGmWMPVgereSZmdHUHC7ZqWCwUNfxfj3xBf/XDDHhpo=";
      };

      vendorHash = "sha256-ZO8sLOaEY3bii9RSxzXDTCcwlsQEYmZDI+X1WPXbE9c=";
    }
  );

  tun2socks' = tun2socks.overrideAttrs (
    finalAttrs: prevAttrs: {
      pname = "tun2socks";
      version = "2.5.2-c8f8cb5";

      src = fetchFromGitHub {
        owner = "xjasonlyu";
        repo = "tun2socks";
        rev = "c8f8cb5caf6796039a08d3ebad5354767795628b";
        hash = "sha256-VF8Mm323w0dwhXyFAJVi67BWepury59sVq1+DDzBjU8=";
      };

      vendorHash = "sha256-fHwr/Hnqufgi3D93GLxd5lqNetJswWvQ0+MqPq3QxV4=";
    }
  );

  amnezia-xray = callPackage ./xray-lib.nix { };

  amneziaPremiumConfig = fetchurl {
    url = "https://raw.githubusercontent.com/amnezia-vpn/amnezia-client-lite/f45d6b242c1ac635208a72914e8df76ccb3aa44c/macos-signed-build.sh";
    hash = "sha256-PnaPVPlyglUphhknWwP7ziuwRz+WOz0k9WRw6Q0nG2c=";
    postFetch = ''
      sed -nri '/PROD_AGW_PUBLIC_KEY|PROD_S3_ENDPOINT/p' $out
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "amnezia-vpn";
  version = "4.8.15.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amnezia-client";
    tag = finalAttrs.version;
    hash = "sha256-ZUWesEpXb+L7NzL/jkWpS3b4DGq4733T5zc+VXSw9Ic=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace client/platforms/linux/daemon/wireguardutilslinux.cpp \
      --replace-fail 'm_tunnel.start(appPath.filePath("../../client/bin/wireguard-go"), wgArgs);' 'm_tunnel.start("${amneziawg'}/bin/amneziawg-go", wgArgs);'
    substituteInPlace client/utilities.cpp \
      --replace-fail 'return Utils::executable("../../client/bin/openvpn", true);' 'return Utils::executable("${openvpn}/bin/openvpn", false);' \
      --replace-fail 'return Utils::executable("../../client/bin/tun2socks", true);' 'return Utils::executable("${tun2socks'}/bin/tun2socks", false);' \
      --replace-fail 'return Utils::usrExecutable("wg-quick");' 'return Utils::executable("${wireguard-tools}/bin/wg-quick", false);'
    substituteInPlace client/protocols/openvpnovercloakprotocol.cpp \
      --replace-fail 'return Utils::executable(QString("/ck-client"), true);' 'return Utils::executable(QString("${cloak-pt}/bin/ck-client"), false);'
    substituteInPlace client/protocols/shadowsocksvpnprotocol.cpp \
      --replace-fail 'return Utils::executable(QString("/ss-local"), true);' 'return Utils::executable(QString("${shadowsocks-rust}/bin/sslocal"), false);'
    substituteInPlace client/configurators/openvpn_configurator.cpp \
      --replace-fail ".arg(qApp->applicationDirPath());" ".arg(\"$out/libexec\");" \
      --replace-fail "int nVersion = 1;" "int nVersion = 0;"
    substituteInPlace client/ui/qautostart.cpp \
      --replace-fail "/usr/share/pixmaps/AmneziaVPN.png" "AmneziaVPN"
    substituteInPlace deploy/installer/config/AmneziaVPN.desktop.in \
      --replace-fail "/usr/share/pixmaps/AmneziaVPN.png" "$out/share/icons/hicolor/512x512/apps/AmneziaVPN.png"
    substituteInPlace deploy/data/linux/AmneziaVPN.service \
      --replace-fail "ExecStart=/opt/AmneziaVPN/service/AmneziaVPN-service.sh" "ExecStart=$out/bin/AmneziaVPN-service" \
      --replace-fail "Environment=LD_LIBRARY_PATH=/opt/AmneziaVPN/client/lib" ""
    substituteInPlace client/cmake/3rdparty.cmake \
      --replace-fail 'set(LIBSSH_LIB_PATH "''${LIBSSH_ROOT_DIR}/linux/x86_64/libssh.a")' 'set(LIBSSH_LIB_PATH "${libssh}/lib/libssh.so")' \
      --replace-fail 'set(ZLIB_LIB_PATH "''${LIBSSH_ROOT_DIR}/linux/x86_64/libz.a")' 'set(ZLIB_LIB_PATH "${zlib}/lib/libz.so")' \
      --replace-fail 'set(OPENSSL_INCLUDE_DIR "''${OPENSSL_ROOT_DIR}/linux/include")' 'set(OPENSSL_INCLUDE_DIR "${openssl.dev}/include")' \
      --replace-fail 'set(OPENSSL_LIB_SSL_PATH "''${OPENSSL_ROOT_DIR}/linux/x86_64/libssl.a")' 'set(OPENSSL_LIB_SSL_PATH "${openssl.out}/lib/libssl.so")' \
      --replace-fail 'set(OPENSSL_LIB_CRYPTO_PATH "''${OPENSSL_ROOT_DIR}/linux/x86_64/libcrypto.a")' 'set(OPENSSL_LIB_CRYPTO_PATH "${openssl.out}/lib/libcrypto.so")' \
      --replace-fail 'set(OPENSSL_USE_STATIC_LIBS TRUE)' 'set(OPENSSL_USE_STATIC_LIBS FALSE)'
    substituteInPlace service/server/CMakeLists.txt \
      --replace-fail 'set(OPENSSL_INCLUDE_DIR "''${OPENSSL_ROOT_DIR}/linux/include")' 'set(OPENSSL_INCLUDE_DIR "${openssl.dev}/include")' \
      --replace-fail 'set(OPENSSL_LIB_CRYPTO_PATH "''${OPENSSL_ROOT_DIR}/linux/x86_64/libcrypto.a")' 'set(OPENSSL_LIB_CRYPTO_PATH "${openssl.out}/lib/libcrypto.so")' \
      --replace-fail 'set(OPENSSL_USE_STATIC_LIBS TRUE)' 'set(OPENSSL_USE_STATIC_LIBS FALSE)' \
      --replace-fail 'set(AMNEZIA_XRAY_LIB_PATH "''${AMNEZIA_XRAY_ROOT_DIR}/linux/x86_64/amnezia_xray.a")' 'set(AMNEZIA_XRAY_LIB_PATH "${amnezia-xray}/lib/amnezia_xray.a")' \
      --replace-fail 'set(AMNEZIA_XRAY_INCLUDE_DIR "''${AMNEZIA_XRAY_ROOT_DIR}/linux/x86_64")' 'set(AMNEZIA_XRAY_INCLUDE_DIR "${amnezia-xray}/include")'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    bash
    kdePackages.qt5compat
    kdePackages.qtremoteobjects
    kdePackages.qtsvg
    libsecret
    qt6.qtbase
    qt6.qttools
  ];

  preConfigure = ''
    source ${amneziaPremiumConfig}
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 client/AmneziaVPN service/server/AmneziaVPN-service -t $out/bin/
    install -Dm555 ../deploy/data/linux/client/bin/update-resolv-conf.sh -t $out/libexec/
    install -Dm444 ../AppDir/AmneziaVPN.desktop -t $out/share/applications/
    install -Dm444 ../deploy/data/linux/AmneziaVPN.png -t $out/share/icons/hicolor/512x512/apps
    install -Dm444 ../deploy/data/linux/AmneziaVPN.service -t $out/lib/systemd/system/

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Amnezia VPN Client";
    downloadPage = "https://amnezia.org/en/downloads";
    homepage = "https://github.com/amnezia-vpn/amnezia-client";
    license = lib.licenses.gpl3;
    mainProgram = "AmneziaVPN";
    maintainers = with lib.maintainers; [ sund3RRR ];
    platforms = lib.platforms.linux;
  };
})
