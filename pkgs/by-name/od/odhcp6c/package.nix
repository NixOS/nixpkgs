{
  lib,
  stdenv,
  fetchgit,
  cmake,
  libubox,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "odhcp6c";
  version = "0-unstable-2025-12-29";

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcp6c.git";
    rev = "8abb45065f5ef9d176efa6bd151a1209b05852c4";
    hash = "sha256-xly6FAp8yddBnJeCSupVIq0Wec+sSFuuKH91MNKvHwM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libubox ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
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
