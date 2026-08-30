{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libmnl,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.3.1";
  pname = "libnftnl";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnftnl/files/libnftnl-${finalAttrs.version}.tar.xz";
    hash = "sha256-YH2ijbpm+97M+O8Tld3tkHfo0Z8plfmk1FqcLwvP+6g=";
  };

  configureFlags = lib.optional (
    stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
  ) "LDFLAGS=-Wl,--undefined-version";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.netfilter.org/libnftnl";
    rev-prefix = "libnftnl-";
  };

  meta = {
    description = "Userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = "https://netfilter.org/projects/libnftnl/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fpletz ];
  };
})
