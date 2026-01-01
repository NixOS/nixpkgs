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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snort";
<<<<<<< HEAD
  version = "3.10.0.0";
=======
  version = "3.9.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "snort3";
    repo = "snort3";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-vxiZeJByZGS7rXtvPMgNjb94E/oju+mmEuzJ7tA+hE4=";
=======
    hash = "sha256-oJTRTcPQ3ByC2v9yM3yp7UVZqcX84StP4Ii96ZX/sIQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Network intrusion prevention and detection system (IDS/IPS)";
    homepage = "https://www.snort.org";
    maintainers = with lib.maintainers; [
      aycanirican
      brianmcgillion
    ];
    changelog = "https://github.com/snort3/snort3/blob/${finalAttrs.src.rev}/ChangeLog.md";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux;
  };
})
