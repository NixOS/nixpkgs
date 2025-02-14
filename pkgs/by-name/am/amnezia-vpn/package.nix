{
  lib,
  stdenv,
  fetchFromGitHub,
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
  procps,
  iproute2,
  sudo,
  libssh,
  zlib,
  tun2socks,
  xray,
  nix-update-script,
}:
let
  amnezia-tun2socks = tun2socks.overrideAttrs (
    finalAttrs: prevAttrs: {
      pname = "amnezia-tun2socks";
      version = "2.5.4";

      src = fetchFromGitHub {
        owner = "amnezia-vpn";
        repo = "amnezia-tun2socks";
        tag = "v${finalAttrs.version}";
        hash = "sha256-lHo7WtcqccBSHly6neuksh1gC7RCKxbFNX9KSKNNeK8=";
      };

      vendorHash = "sha256-VvOaTJ6dBFlbGZGxnHy2sCtds1tyhu6VsPewYpsDBiM=";
    }
  );

  amnezia-xray = xray.overrideAttrs (
    finalAttrs: prevAttrs: {
      pname = "amnezia-xray";
      version = "1.8.13";

      src = fetchFromGitHub {
        owner = "amnezia-vpn";
        repo = "amnezia-xray-core";
        tag = "v${finalAttrs.version}";
        hash = "sha256-7XYdogoUEv3kTPTOQwRCohsPtfSDf+aRdI28IkTjvPk=";
      };

      vendorHash = "sha256-zArdGj5yeRxU0X4jNgT5YBI9SJUyrANDaqNPAPH3d5M=";
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "amnezia-vpn";
  version = "4.8.3.1";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amnezia-client";
    tag = finalAttrs.version;
    hash = "sha256-U/fVO9GcSdxFg5r57vX5Ylgu6CMjG4GKyInIgBNUiEw=";
    fetchSubmodules = true;
  };

  postPatch =
    ''
      substituteInPlace client/platforms/linux/daemon/wireguardutilslinux.cpp \
        --replace-fail 'm_tunnel.start(appPath.filePath("../../client/bin/wireguard-go"), wgArgs);' 'm_tunnel.start("${amneziawg-go}/bin/amneziawg-go", wgArgs);'
      substituteInPlace client/utilities.cpp \
        --replace-fail 'return Utils::executable("../../client/bin/openvpn", true);' 'return Utils::executable("${openvpn}/bin/openvpn", false);' \
        --replace-fail 'return Utils::executable("../../client/bin/tun2socks", true);' 'return Utils::executable("${amnezia-tun2socks}/bin/amnezia-tun2socks", false);' \
        --replace-fail 'return Utils::usrExecutable("wg-quick");' 'return Utils::executable("${wireguard-tools}/bin/wg-quick", false);'
      substituteInPlace client/protocols/xrayprotocol.cpp \
        --replace-fail 'return Utils::executable(QString("xray"), true);' 'return Utils::executable(QString("${amnezia-xray}/bin/xray"), false);'
      substituteInPlace client/protocols/openvpnovercloakprotocol.cpp \
        --replace-fail 'return Utils::executable(QString("/ck-client"), true);' 'return Utils::executable(QString("${cloak-pt}/bin/ck-client"), false);'
      substituteInPlace client/protocols/shadowsocksvpnprotocol.cpp \
        --replace-fail 'return Utils::executable(QString("/ss-local"), true);' 'return Utils::executable(QString("${shadowsocks-rust}/bin/sslocal"), false);'
      substituteInPlace client/configurators/openvpn_configurator.cpp \
        --replace-fail ".arg(qApp->applicationDirPath());" ".arg(\"$out/libexec\");"
      substituteInPlace client/ui/qautostart.cpp \
        --replace-fail "/usr/share/pixmaps/AmneziaVPN.png" "$out/share/pixmaps/AmneziaVPN.png"
      substituteInPlace deploy/installer/config/AmneziaVPN.desktop.in \
        --replace-fail "/usr/share/pixmaps/AmneziaVPN.png" "$out/share/pixmaps/AmneziaVPN.png"
      substituteInPlace deploy/data/linux/AmneziaVPN.service \
        --replace-fail "ExecStart=/opt/AmneziaVPN/service/AmneziaVPN-service.sh" "ExecStart=$out/bin/AmneziaVPN-service" \
        --replace-fail "Environment=LD_LIBRARY_PATH=/opt/AmneziaVPN/client/lib" ""
    ''
    + (lib.optionalString (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) ''
      substituteInPlace client/cmake/3rdparty.cmake \
        --replace-fail 'set(LIBSSH_LIB_PATH "''${LIBSSH_ROOT_DIR}/linux/x86_64/libssh.a")' 'set(LIBSSH_LIB_PATH "${libssh}/lib/libssh.so")' \
        --replace-fail 'set(ZLIB_LIB_PATH "''${LIBSSH_ROOT_DIR}/linux/x86_64/libz.a")' 'set(ZLIB_LIB_PATH "${zlib}/lib/libz.so")' \
        --replace-fail 'set(OPENSSL_LIB_SSL_PATH "''${OPENSSL_ROOT_DIR}/linux/x86_64/libssl.a")' 'set(OPENSSL_LIB_SSL_PATH "''${OPENSSL_ROOT_DIR}/linux/arm64/libssl.a")' \
        --replace-fail 'set(OPENSSL_LIB_CRYPTO_PATH "''${OPENSSL_ROOT_DIR}/linux/x86_64/libcrypto.a")' 'set(OPENSSL_LIB_CRYPTO_PATH "''${OPENSSL_ROOT_DIR}/linux/arm64/libcrypto.a")'
    '');

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libsecret
    qt6.qtbase
    qt6.qttools
    kdePackages.qtremoteobjects
    kdePackages.qtsvg
    kdePackages.qt5compat
  ];

  qtWrapperArgs = [
    ''--prefix PATH : ${
      lib.makeBinPath [
        procps
        iproute2
        sudo
      ]
    }''
  ];

  postInstall = ''
    mkdir -p $out/bin $out/libexec $out/share/applications $out/share/pixmaps $out/lib/systemd/system
    cp client/AmneziaVPN service/server/AmneziaVPN-service $out/bin/
    cp ../deploy/data/linux/client/bin/update-resolv-conf.sh $out/libexec/
    cp ../AppDir/AmneziaVPN.desktop $out/share/applications/
    cp ../deploy/data/linux/AmneziaVPN.png $out/share/pixmaps/
    cp ../deploy/data/linux/AmneziaVPN.service $out/lib/systemd/system/
  '';

  passthru = {
    inherit amnezia-tun2socks amnezia-xray;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "amnezia-tun2socks"
        "--subpackage"
        "amnezia-xray"
      ];
    };
  };

  meta = with lib; {
    description = "Amnezia VPN Client";
    downloadPage = "https://amnezia.org/en/downloads";
    homepage = "https://amnezia.org/en";
    license = licenses.gpl3;
    mainProgram = "AmneziaVPN";
    maintainers = with maintainers; [ sund3RRR ];
    platforms = platforms.unix;
  };
})
