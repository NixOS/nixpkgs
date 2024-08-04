{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  systemdLibs,
  avahi,
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
  version = "0-unstable-2024-10-18";

  src = fetchFromGitHub {
    owner = "openthread";
    repo = "ot-br-posix";
    rev = "76bfeef4e3e0242c235aa6bdf5480a0642883599";
    hash = "sha256-VtekJD++PAse+yNmWzpO8lsyw0jnEsRFrzs/wK6VqqM=";
    fetchSubmodules = true;
  };

  # hass-addons contains a few patches
  hass-addons = fetchFromGitHub {
    owner = "home-assistant";
    repo = "addons";
    rev = "583a62a69fa92ca8fdf9a2f298270a50bb3663a1";
    hash = "sha256-u+lvU7mlJZqCCDIT4n7WnHyzAd0nZCh9Ddvqjs4SkHA=";
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
    # Skip installing systemd units since it doesn't respect the installation prefix and attempts
    # to install them at their final location
    ./dont-install-systemd-units.patch
    ./dont-use-boost-static-libs.patch
    # Patch the firewall script so we can run it within the systemd start script
    ./firewall-script.patch
    "${hass-addons}/openthread_border_router/0002-rest-support-deleting-the-dataset.patch"
  ];

  postPatch = ''
    pushd third_party/openthread/repo
    patch -p1 -i "${hass-addons}/openthread_border_router/0001-channel-monitor-disable-by-default.patch"
    popd
  '';

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
  ];

  postInstall = ''
    mkdir -p $out/bin
    echo "PWD: "$(pwd)
    echo "SRC: ${src}"
    cp ../script/otbr-firewall $out/bin/
    chmod +x $out/bin/otbr-firewall
  '';

  cmakeFlags = [
    # These defaults are from "examples/platforms/raspbian/default and script/_otbr
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "OTBR_REST" true)

    (lib.cmakeBool "OTBR_WEB" true)
    (lib.cmakeBool "OTBR_NAT64" true)
    (lib.cmakeBool "OTBR_BACKBONE_ROUTER" true)
    (lib.cmakeBool "OTBR_BORDER_ROUTING" true)
    (lib.cmakeBool "OTBR_DBUS" false)
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
