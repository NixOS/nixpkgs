{ lib, stdenv, fetchurl, pkg-config, libmnl, gitUpdater }:

stdenv.mkDerivation rec {
  version = "1.2.8";
  pname = "libnftnl";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.xz";
    hash = "sha256-N/6l1rXJsI3nkg0pjePNyULnrmSxo+i4gLLTkK5nrZU=";
  };

  configureFlags = lib.optional (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17") "LDFLAGS=-Wl,--undefined-version";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.netfilter.org/libnftnl";
    rev-prefix = "libnftnl-";
  };

  meta = with lib; {
    description = "Userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = "https://netfilter.org/projects/libnftnl/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
