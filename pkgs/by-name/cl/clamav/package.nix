{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  cmake,
  zlib,
  bzip2,
  libiconv,
  libxml2,
  openssl,
  ncurses,
  curl,
  libmilter,
  pcre2,
  libmspack,
  systemdLibs,
  systemdSupport ? stdenv.hostPlatform.isLinux,
  json_c,
  check,
  rustc,
  rust-bindgen,
  rustfmt,
  cargo,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clamav";
  version = "1.5.4";

  src = fetchurl {
    url = "https://www.clamav.net/downloads/production/clamav-${finalAttrs.version}.tar.gz";
    hash = "sha256-GvEReiKPG1vH+pGg2rw3hIqZ59JRiOm+gEMzLOch39M=";
  };

  patches = [
    ./sample-configuration-file-install-location.patch
    ./use-non-existent-file-with-proper-permissions.patch
  ];

  enableParallelBuilding = true;
  nativeBuildInputs = [
    cmake
    pkg-config
    rustc
    rust-bindgen
    rustfmt
    cargo
    python3
  ];
  buildInputs = [
    zlib
    bzip2
    libxml2
    openssl
    ncurses
    curl
    libiconv
    libmilter
    pcre2
    libmspack
    json_c
    check
  ]
  ++ lib.optional systemdSupport systemdLibs;

  cmakeFlags = [
    "-DAPP_CONFIG_DIRECTORY=/etc/clamav"
    "-DCVD_CERTS_DIRECTORY=${placeholder "out"}/share/clamav/certs"
  ]
  ++ lib.optionals systemdSupport [
    "-DSYSTEMD_UNIT_DIR=${placeholder "out"}/lib/systemd"
  ];

  # Fails on darwin with sandboxing
  doCheck = !(stdenv.hostPlatform.isDarwin);

  checkInputs = [
    python3.pkgs.pytest
  ];

  meta = {
    homepage = "https://www.clamav.net";
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      robberer
      qknight
    ];
    platforms = lib.platforms.unix;
  };
})
