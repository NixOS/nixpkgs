{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libmnl,
  gitUpdater,
}:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "libnftnl";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.xz";
<<<<<<< HEAD
    hash = "sha256-YH2ijbpm+97M+O8Tld3tkHfo0Z8plfmk1FqcLwvP+6g=";
=======
    hash = "sha256-D0vkeou4t3o1DuWMvUtfrmJgrUhqUncGqxXP4d1Vo8Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = "https://netfilter.org/projects/libnftnl/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fpletz ];
=======
  meta = with lib; {
    description = "Userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = "https://netfilter.org/projects/libnftnl/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
