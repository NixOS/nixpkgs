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
  version = "0-unstable-2026-06-27";

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcp6c.git";
    rev = "10a52220aec9d45803518d8cc4d63e552484ed61";
    hash = "sha256-IDBbVWs017JcrApJ3s8fjEQghWCwrK1d+E6Wp5eHNX4=";
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
