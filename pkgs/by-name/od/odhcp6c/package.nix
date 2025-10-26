{
  lib,
  stdenv,
  fetchgit,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "odhcp6c";
  version = "0-unstable-2025-10-17";

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcp6c.git";
    rev = "d7afeea2b9650c64fcf915cbb3369577247b96ed";
    hash = "sha256-6L/yY8u5JBw1oywj2pg+0rW2397KBNAejrg5VKpYxLw=";
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
