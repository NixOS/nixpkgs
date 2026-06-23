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
  version = "0-unstable-2026-06-20";

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcp6c.git";
    rev = "07d324ee7222c0e15b9975281f18236fdccc11bd";
    hash = "sha256-OAq8OMLRVSQ8o36+XOj0pT+kBcVMnjFF2/7T2GWNpYo=";
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
