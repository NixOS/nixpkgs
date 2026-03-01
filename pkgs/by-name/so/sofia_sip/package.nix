{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  gitUpdater,
  testers,
  autoconf,
  automake,
  check,
  glib,
  libtool,
  openssl,
  pkg-config,
  valgrind,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sofia-sip";
  version = "1.13.17";

  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = "sofia-sip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7QmK2UxEO5lC0KBDWB3bwKTy0Nc7WrdTLjoQYzezoaY=";
  };

  patches = [
    # Fix build with gcc 14 from https://github.com/freeswitch/sofia-sip/pull/249
    (fetchpatch2 {
      name = "sofia-sip-fix-incompatible-pointer-type.patch";
      url = "https://github.com/freeswitch/sofia-sip/commit/46b02f0655af0a9594e805f09a8ee99278f84777.patch?full_index=1";
      hash = "sha256-bZzjg7GBxR2wSlPH81krZRCK43OirGLWH/lrLRZ0L0k=";
    })

    # Disable some failing tests
    # https://github.com/freeswitch/sofia-sip/issues/234
    # run_addrinfo: Fails due to limited networking during build
    # torture_su_root: Aborts with: bit out of range 0 - FD_SETSIZE on fd_set
    # run_check_nta: Times out in client_2_1_1 test, which seems to test some connection protocol fallback thing
    # run_test_nta: "no valid IPv6 addresses available", likely due to no networking in sandbox
    # check_nua, check_sofia, test_nua: Times out no matter how much time is given to it
    ./2001-sofia-sip-Disable-some-tests.patch
  ];

  # This actually breaks these tests, leading to bash trying to execute itself
  # https://github.com/freeswitch/sofia-sip/issues/234
  postPatch = ''
    substituteInPlace libsofia-sip-ua/nta/Makefile.am \
      --replace-fail 'TESTS_ENVIRONMENT =' '#TESTS_ENVIRONMENT ='
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    glib
    openssl
  ];

  nativeCheckInputs = [
    valgrind
  ];

  checkInputs = [
    check
    zlib
  ];

  preConfigure = ''
    ./bootstrap.sh
  '';

  configureFlags = [
    (lib.strings.enableFeature true "expensive-checks")
  ];

  enableParallelBuilding = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    description = "Open-source SIP User-Agent library, compliant with the IETF RFC3261 specification";
    homepage = "https://github.com/freeswitch/sofia-sip";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl2Plus;
    teams = [ lib.teams.ngi ];
    pkgConfigModules = [
      "sofia-sip-ua"
      "sofia-sip-ua-glib"
    ];
  };
})
