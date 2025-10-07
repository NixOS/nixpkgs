{
  lib,
  stdenv,
  fetchgit,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "odhcp6c";
  version = "0-unstable-2025-10-03";

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcp6c.git";
    rev = "96d9e0b6e81330c61c954c6bc73a2302276fcda1";
    hash = "sha256-EhkzSKf1t4MrGCN5oC1h0QJiY9w8VhMsa/jor4lEvD4=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Embedded DHCPv6-client for OpenWrt";
    homepage = "https://openwrt.org/packages/pkgdata/odhcp6c";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
}
