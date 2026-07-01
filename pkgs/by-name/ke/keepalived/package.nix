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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6vh/Y8PPT7/vRAS/y+0RDAPqMEJxmAwX5Uh3qh+T14c=";
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

  passthru.tests = nixosTests.keepalived;

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
