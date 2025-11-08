{
  lib,
  stdenv,
  fetchgit,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "odhcp6c";
  version = "0-unstable-2025-10-21";

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcp6c.git";
    rev = "77e1ae21e67f81840024ffe5bb7cf69a8fb0d2f0";
    hash = "sha256-aOW0rOGd4YwnfXjsUj6HHy8zf0FJYFjsKMWJ5yhUl5g=";
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
