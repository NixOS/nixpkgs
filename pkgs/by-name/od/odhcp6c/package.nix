{
  lib,
  stdenv,
  fetchgit,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "odhcp6c";
  version = "0-unstable-2025-02-06";

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcp6c.git";
    rev = "8aa8b706727a6a6a841be42ef35a629ed635db3e";
    hash = "sha256-cFDiT8EC8/2yuLM6dTWTzwxSbFpc7zuUKx2SHbR4PfQ=";
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
