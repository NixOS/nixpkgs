{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

stdenv.mkDerivation rec {
  pname = "sofia-sip";
  version = "1.13.17";

  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = "sofia-sip";
    rev = "v${version}";
    sha256 = "sha256-7QmK2UxEO5lC0KBDWB3bwKTy0Nc7WrdTLjoQYzezoaY=";
  };

  patches = [
    # Fix build with gcc 14 from https://github.com/freeswitch/sofia-sip/pull/249
    (fetchpatch2 {
      name = "sofia-sip-fix-incompatible-pointer-type.patch";
      url = "https://github.com/freeswitch/sofia-sip/commit/46b02f0655af0a9594e805f09a8ee99278f84777.diff";
      hash = "sha256-4uZVtKnXG+BPW8byjd7tu4uEZo9SYq9EzTEvMwG0Bak=";
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

  meta = with lib; {
    description = "Open-source SIP User-Agent library, compliant with the IETF RFC3261 specification";
    homepage = "https://github.com/freeswitch/sofia-sip";
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
