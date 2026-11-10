{
  lib,
  stdenv,
  fetchgit,
  cmake,
  json_c,
  libnl-tiny,
  libubox,
  ubus,
  uci,
  unstableGitUpdater,
  withDhcpv4 ? true,
  withUbus ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "odhcpd";
  version = "0-unstable-2026-11-08";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcpd.git";
    rev = "f97b5d335c513cedd5b81ef9f39bdc799de8f535";
    hash = "sha256-0FzNElifbL/YRrprErROSSE9tpox/cSz3f9IXTLSmSk=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    json_c
    libnl-tiny
    libubox
    uci
  ]
  ++ lib.optional withUbus ubus;

  cmakeFlags = [
    (lib.cmakeBool "UBUS" withUbus)
    (lib.cmakeBool "DHCPV4_SUPPORT" withDhcpv4)
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Embedded DHCP, DHCPv6 and router advertisement server for OpenWrt";
    homepage = "https://openwrt.org/docs/techref/odhcpd";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ savyajha ];
    platforms = lib.platforms.linux;
    mainProgram = "odhcpd";
  };
})
