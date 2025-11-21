{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  libpcap,
  cmake,
  openssl,
  lksctp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sipp";
  version = "3.7.5";

  src = fetchFromGitHub {
    owner = "SIPp";
    repo = "sipp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W5KOvBBaUmyYJshYEg39QpkS8rrpGSEj4g3NZD29YrY=";
  };

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
