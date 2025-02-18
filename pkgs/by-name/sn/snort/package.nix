{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libdaq,
  libdnet,
  flex,
  hwloc,
  luajit,
  openssl,
  libpcap,
  pcre2,
  pkg-config,
  zlib,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snort";
  version = "3.6.3.0";

  src = fetchFromGitHub {
    owner = "snort3";
    repo = "snort3";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-loMmmpoaEncW31FUIE9Zf9w635Prvke6vCY+mIt6oGI=";
  };

  nativeBuildInputs = [
    libdaq
    pkg-config
    cmake
  ];

  buildInputs = [
    libdaq
    libpcap
    stdenv.cc.cc # libstdc++
    libdnet
    flex
    hwloc
    luajit
    openssl
    libpcap
    pcre2
    zlib
    xz
  ];

  # Patch that is tracking upstream PR https://github.com/snort3/snort3/pull/399
  patches = [ ./0001-cmake-fix-pkg-config-path-for-libdir.patch ];

  enableParallelBuilding = true;

  meta = {
    description = "Network intrusion prevention and detection system (IDS/IPS)";
    homepage = "https://www.snort.org";
    maintainers = with lib.maintainers; [
      aycanirican
      brianmcgillion
    ];
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux;
  };
})
