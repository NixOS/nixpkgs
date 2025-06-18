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
  tun2socks,
  xray,
  nix-update-script,
  bash,
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
  version = "4.8.6.0";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amnezia-client";
    tag = finalAttrs.version;
    hash = "sha256-WQbay3dtGNPPpcK1O7bfs/HKO4ytfmQo60firU/9o28=";
    fetchSubmodules = true;
  };

  # Temporary patch header file to fix build with QT 6.9
  patches = [
    (fetchpatch {
      name = "add-missing-include.patch";
      url = "https://github.com/amnezia-vpn/amnezia-client/commit/c44ce0d77cc3acdf1de48a12459a1a821d404a1c.patch";
      hash = "sha256-Q6UMD8PlKAcI6zNolT5+cULECnxNrYrD7cifvNg1ZrY=";
    })
  ];

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
        --replace-fail "/usr/share/pixmaps/AmneziaVPN.png" "AmneziaVPN"
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

    mkdir -p $out/bin $out/libexec $out/share/applications $out/share/pixmaps $out/lib/systemd/system
    install -m555 client/AmneziaVPN service/server/AmneziaVPN-service $out/bin/
    install -m555 ../deploy/data/linux/client/bin/update-resolv-conf.sh $out/libexec/
    install -m444 ../AppDir/AmneziaVPN.desktop $out/share/applications/
    install -m444 ../deploy/data/linux/AmneziaVPN.png $out/share/pixmaps/
    install -m444 ../deploy/data/linux/AmneziaVPN.service $out/lib/systemd/system/

    runHook postInstall
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
    homepage = "https://github.com/amnezia-vpn/amnezia-client";
    license = licenses.gpl3;
    mainProgram = "AmneziaVPN";
    maintainers = with maintainers; [ sund3RRR ];
    platforms = platforms.unix;
  };
})
