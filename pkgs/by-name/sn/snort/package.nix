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
  version = "3.7.0.0";

  src = fetchFromGitHub {
    owner = "snort3";
    repo = "snort3";
    tag = finalAttrs.version;
    hash = "sha256-KwKgKY+zcH7bZrtfMpkwb0LopGeImTwOf79hqZeYv/k=";
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
    changelog = "https://github.com/snort3/snort3/releases/tag/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux;
  };
})
