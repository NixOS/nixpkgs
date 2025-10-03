{
  lib,
  stdenv,
  fetchgit,
  cmake,
  libubox,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "odhcp6c";
  version = "0-unstable-2026-06-03";
  __structuredAttrs = true;

  src = fetchgit {
    url = "https://git.openwrt.org/project/odhcp6c.git";
    rev = "daf4ec3054e753c99fdcc3ac5464926548b38351";
    hash = "sha256-UjvDMA+sDfouW8sMjNc6hqNzHYFrtP5E1M2zHkKBX64=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libubox ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
    defaultScript = "${finalAttrs.src}/odhcp6c-example-script.sh";
  };

  meta = {
    description = "Embedded DHCPv6-client for OpenWrt";
    homepage = "https://openwrt.org/packages/pkgdata/odhcp6c";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
    mainProgram = "odhcp6c";
  };
})
