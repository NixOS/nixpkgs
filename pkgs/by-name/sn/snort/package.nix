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
  version = "3.12.2.0";

  src = fetchFromGitHub {
    owner = "snort3";
    repo = "snort3";
    tag = finalAttrs.version;
    hash = "sha256-YxWIWR8E1bf8+xRFFasZqe284ecd0R922OXDJ2IclDA=";
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
