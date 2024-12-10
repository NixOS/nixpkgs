{
  lib,
  stdenv,
  bzip2,
  cmake,
  doxygen,
  fetchurl,
  fetchpatch,
  fuse,
  libevent,
  xz,
  openssl,
  pkg-config,
  systemd,
  tcp_wrappers,
  zlib,
  c-ares,
}:

stdenv.mkDerivation rec {
  pname = "apt-cacher-ng";
  version = "3.7.4";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_${version}.orig.tar.xz";
    sha256 = "0pwsj9rf6a6q7cnfbpcrfq2gjcy7sylqzqqr49g2zi39lrrh8533";
  };

  patches = [
    # this patch fixes the build for glibc >= 2.38
    (fetchpatch {
      name = "strlcpy-glibc238.patch";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?att=0;bug=1052360;msg=10";
      hash = "sha256-uhQj+ZcHCV36Tm0pF/+JG59bSaRdTZCrMcKL3YhZTk8=";
    })
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];
  buildInputs = [
    bzip2
    fuse
    libevent
    xz
    openssl
    systemd
    tcp_wrappers
    zlib
    c-ares
  ];

  meta = with lib; {
    description = "Caching proxy specialized for Linux distribution files";
    mainProgram = "apt-cacher-ng";
    homepage = "https://www.unix-ag.uni-kl.de/~bloch/acng/";
    license = licenses.bsdOriginal;
    platforms = platforms.linux;
    maintainers = [ maintainers.makefu ];
  };
}
