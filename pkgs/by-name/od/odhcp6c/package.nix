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
  version = "0-unstable-2026-01-25";

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcp6c.git";
    rev = "24485bb4b35ab84c17c2e87bd561d026d4c15c00";
    hash = "sha256-cfBKly95vI+8u6lZ4LyrSrNvCf3ogTKtLDzuodO26qw=";
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
