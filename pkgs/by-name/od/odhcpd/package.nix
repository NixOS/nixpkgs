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
  nixosTests,
  unstableGitUpdater,
  withDhcpv4 ? true,
  withUbus ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "odhcpd";
  version = "0-unstable-2026-11-17";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcpd.git";
    rev = "4580970dabfb289de57fe5297c0be6f578bb30d2";
    hash = "sha256-2T0Nnw84Dj37QK0NBsofcfYNzOeOcg5TUvZ2JxEP7RQ=";
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

  passthru = {
    tests = nixosTests.odhcpd;
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Embedded DHCP, DHCPv6 and router advertisement server for OpenWrt";
    homepage = "https://openwrt.org/docs/techref/odhcpd";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ savyajha ];
    platforms = lib.platforms.linux;
    mainProgram = "odhcpd";
  };
})
