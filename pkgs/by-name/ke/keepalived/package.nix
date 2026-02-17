{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  file,
  libmnl,
  libnftnl,
  libnl,
  net-snmp,
  openssl,
  pkg-config,
  autoreconfHook,
  withNetSnmp ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keepalived";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Xv/UGIeZhRHQO5lxkaWgHDUW+3qBi3wFU4+Us1A2uE0=";
  };

  buildInputs = [
    file
    libmnl
    libnftnl
    libnl
    openssl
  ]
  ++ lib.optionals withNetSnmp [
    net-snmp
  ];

  enableParallelBuilding = true;

  passthru.tests.keepalived = nixosTests.keepalived;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  configureFlags = [
    "--enable-sha1"
  ]
  ++ lib.optionals withNetSnmp [
    "--enable-snmp"
  ];

  meta = {
    homepage = "https://keepalived.org";
    description = "Routing software written in C";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.raitobezarius ];
    mainProgram = "keepalived";
  };
})
