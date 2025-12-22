{
  lib,
  stdenv,
  nixosTests,
  nix-update-script,
  buildNpmPackage,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  avahi,
  cjson,
  jsoncpp,
  http-parser,
  libnetfilter_queue,
  libnfnetlink,
  systemd,
  cpputest,
  gtest,
  boost,
  dbus,
  protobuf,
  dhcpcd,
  nodePackages,
  settingsPath ? "/var/lib/thread",
  ...
}:

buildNpmPackage rec {
  pname = "openthread-border-router";
  version = "20250618";
  npmDepsHash = "sha256-7UVfPICyIbHEClpr3p7eDR46OUzS8mVf6P7phnDpVLk=";
  src = fetchFromGitHub {
    owner = "openthread";
    repo = "ot-br-posix";
    rev = "dcc621476f2586cf4f7a3e2aa93b6db498ac33d3";
    hash = "sha256-KoXqm8POKVIzgTH36gXghJ4sryc0jBxQdERVnINKozI=";
    fetchSubmodules = true;
  };
  patches = [ ./otbr-fix-vendored.patch ];
  postPatch = ''
    rm -rf third_party/{cJSON,http-parser}
    cp src/web/web-service/frontend/package-lock.json .
    cp src/web/web-service/frontend/package.json .
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    protobuf
  ];
  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=20"

    "-DINSTALL_SYSTEMD_UNIT=OFF"
    "-DOT_POSIX_SETTINGS_PATH=\"${settingsPath}\""
    "-DOT_CHANNEL_MANAGER=ON"
    #   "-DOT_CHANNEL_MANAGER_CSL=1"
    #   "-DOT_CSL_RECEIVER=1"
    #   "-DOT_WAKEUP_COORDINATOR=1"
    "-DOT_CHANNEL_MONITOR=ON"
    "-DOT_DNS_CLIENT=ON"
    "-DOT_DNSSD_SERVER=ON"
    "-DOT_DNSSD_DISCOVERY_PROXY=ON"
    
    "-DOT_PLATFORM_DNSSD=ON"
    "-DOT_TREL=ON"
    #    "-DOT_TREL_MANAGE_DNSSD=ON"
    "-DOT_DNS_UPSTREAM_QUERY=ON"
    "-DOTBR_BORDER_ROUTING=ON"
    "-DOTBR_BACKBONE_ROUTER=ON"

    "-DOTBR_DUA_ROUTING=ON"
    "-DOTBR_FEATURE_FLAGS=ON"
    "-DOTBR_REST=ON"
    
    "-DOTBR_OPENWRT=OFF"
    "-DOTBR_DHCP6_PD=ON"
    #   "-DOTBR_NAT64=1"
    "-DOTBR_WEB=ON"
    "-DOTBR_TREL=ON"
    "-DOTBR_DNSSD_PLAT=ON"
    "-DOTBR_DHCP6_PD=ON"
    "-DOTBR_DNS_UPSTREAM_QUERY=ON"
    "-DOTBR_DNSSD_DISCOVERY_PROXY=ON"
    "-DOTBR_SRP_SERVER_AUTO_ENABLE=ON"
    "-DOTBR_SRP_ADVERTISING_PROXY=ON"
    "-DOTBR_TELEMETRY_DATA_API=ON"
    "-DOTBR_DBUS=ON"
    "-DOTBR_POWER_CALIBRATION=ON"
    "-DOTBR_LINK_METRICS_TELEMETRY=ON"
    "-DOTBR_FEATURE_FLAGS=ON"
    "-DGTest_DIR=${gtest.dev}/lib/cmake/GTest"

  ];

  buildInputs = [
    avahi
    (boost.override {
      enableShared = false;
      enabledStatic = true;
    })
    protobuf
    http-parser
    cjson
    jsoncpp
    systemd
    dbus
    nodePackages.nodejs
    libnetfilter_queue
    libnfnetlink
    dhcpcd
  ];

  # greps /var/log/syslog in the build sandbox
  doCheck = false;

  nativeCheckInputs = [ cpputest gtest.dev ];
  passthru = {
    # updateScript = nix-update-script {
    #   extraArgs = [
    #     "--version=branch=main"
    #     "--test"
    #   ];
    # };
  };
  meta = {
    description = "OpenThread Border Router, a Thread border router for POSIX-based platforms";
    homepage = "https://github.com/openthread/ot-br-posix";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ spacekitteh ];
    mainProgram = "ot-br-posix";
    platforms = lib.platforms.all;
  };
}
