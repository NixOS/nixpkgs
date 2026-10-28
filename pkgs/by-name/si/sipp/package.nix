{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  libpcap,
  cmake,
  openssl,
  lksctp-tools,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sipp";
  version = "3.7.7";

  src = fetchFromGitHub {
    owner = "SIPp";
    repo = "sipp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1JKKD3rEddCzXrbNpbzvhFXlTlkTXlP7vmRXvlGzkgI=";
  };

  # TODO: Remove this patches once SIPP releases a version newer than 3.7.7.
  patches = [
    (fetchpatch {
      name = "CVE-2026-90780.patch";
      url = "https://github.com/SIPp/sipp/commit/8ddfb43359703e665041a955543e07f504f80232.patch";
      hash = "sha256-MYzy6C5yOwEJ7lo+GDdfTRlJ1t4ABtnm7ha+gAwoARo=";
    })
    (fetchpatch {
      name = "CVE-2026-90779.patch";
      url = "https://github.com/SIPp/sipp/commit/09916a92de768ab08056a78e4731f9edc3853e1c.patch";
      hash = "sha256-MJe6SMT3yNzbep9/eC4ELCqxMKwe/v9ZkB4q/R0dpUg=";
    })
    (fetchpatch {
      name = "CVE-2026-90778.patch";
      url = "https://github.com/SIPp/sipp/commit/d913c75c4ac55fe6d2b79c6dc23d8aa36dbc5283.patch";
      hash = "sha256-SEufhy4qB8PTWVwr5TE783P0yWjZk2/jcBGlqtJIbXc=";
    })
  ];

  postPatch = ''
    echo '#define SIPP_VERSION VERSION' > include/version.h
    echo '#define VERSION "v${finalAttrs.version}"' >> include/version.h
  '';

  cmakeFlags = [
    "-DUSE_PCAP=1"
    "-DUSE_SSL=1"
    "-DUSE_SCTP=${if stdenv.hostPlatform.isLinux then "1" else "0"}"

    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    ncurses
    libpcap
    openssl
  ]
  ++ lib.optional (stdenv.hostPlatform.isLinux) lksctp-tools;

  meta = {
    homepage = "http://sipp.sf.net";
    description = "SIPp testing tool";
    mainProgram = "sipp";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
})
