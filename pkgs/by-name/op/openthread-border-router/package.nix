{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  systemdLibs,
  avahi,
  dbus,
  protobuf,
  jsoncpp,
  boost,
  libnetfilter_queue,
  libnfnetlink,
  nodejs,
  buildNpmPackage,
}:
let
  pname = "ot-br-posix";
  version = "0-unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "openthread";
    repo = "ot-br-posix";
    rev = "387fef65d3f89901175f4d8bb7f6aa7a66cf94c0";
    hash = "sha256-sEOUCx9G9/NSk/m6FpF9DXHQzHpX+VKRfnpgnF4mO7g=";
    fetchSubmodules = true;
  };

  frontendModules = buildNpmPackage {
    pname = "${pname}-frontend";
    inherit version;
    src = "${src}/src/web/web-service/frontend";
    npmDepsHash = "sha256-7UVfPICyIbHEClpr3p7eDR46OUzS8mVf6P7phnDpVLk=";
    dontNpmBuild = true;
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  # warning _FORTIFY_SOURCE requires compiling with optimization (-O)
  env.NIX_CFLAGS_COMPILE = "-O";

  patches = [
    # Patch the firewall script so we can run it within the systemd start script
    ./firewall-script.patch
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    nodejs
  ];

  # Adding npmConfigHook and manually passing fetchNpmDeps was resulting in ENOTCACHED errors
  postConfigure = ''
    ln -sf ${frontendModules}/lib/node_modules/otbr-web/node_modules ./src/web/web-service/frontend/
  '';

  buildInputs = [
    avahi
    systemdLibs
    protobuf
    jsoncpp
    boost
    libnetfilter_queue
    libnfnetlink
    dbus
  ];

  postInstall = ''
    mkdir -p $out/bin
    cp ../script/otbr-firewall $out/bin/
    chmod +x $out/bin/otbr-firewall
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")

    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "INSTALL_SYSTEMD_UNIT" false)
    (lib.cmakeBool "Boost_USE_STATIC_LIBS" false)
    (lib.cmakeBool "OTBR_REST" true)

    (lib.cmakeBool "OTBR_WEB" true)
    (lib.cmakeBool "OTBR_NAT64" true)
    (lib.cmakeBool "OTBR_BACKBONE_ROUTER" true)
    (lib.cmakeBool "OTBR_BORDER_ROUTING" true)
    (lib.cmakeBool "OTBR_DBUS" true)
    (lib.cmakeBool "OTBR_TREL" true)

    (lib.cmakeFeature "OTBR_VERSION" version)
    (lib.cmakeBool "OTBR_DNSSD_DISCOVERY_PROXY" true)
    (lib.cmakeBool "OTBR_SRP_ADVERTISING_PROXY" true)
    (lib.cmakeBool "OTBR_DUA_ROUTING" true)
    (lib.cmakeBool "OTBR_DNS_UPSTREAM_QUERY" true)

    (lib.cmakeBool "OT_CHANNEL_MANAGER" true)
    (lib.cmakeBool "OT_CHANNEL_MONITOR" true)

    # Required by protobuf
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
  ];

  meta = {
    description = "Thread border router for POSIX-based platforms";
    homepage = "https://github.com/openthread/ot-br-posix";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mrene ];
    mainProgram = "ot-ctl";
    platforms = lib.platforms.linux;
  };
}
