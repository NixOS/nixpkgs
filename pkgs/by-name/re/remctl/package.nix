{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libevent,
  krb5,
  openssl,
  perl,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "remctl";
  version = "3.18";

  src = fetchFromGitHub {
    owner = "rra";
    repo = "remctl";
    rev = "release/${finalAttrs.version}";
    hash = "sha256-4KzNhFswNTwcXrDBAfRyr502zwRQ3FACV8gDfBm7M0A=";
  };

  # Fix references to /usr/bin/perl in tests and
  # disable acl/localgroup test that does not work in sandbox.
  postPatch = ''
    patchShebangs tests
    sed -i '\,server/acl/localgroup,d' tests/TESTS

    substituteInPlace Makefile.am \
      --replace-fail "tests/data/acls/val\#id" "'tests/data/acls/val#id'"
  '';

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
  ];

  buildInputs = [
    krb5
    libevent
    openssl
  ];

  # Invokes pod2man to create man pages required by Makefile.
  preConfigure = ''
    ./bootstrap
  '';

  makeFlags = [
    "LD=$(CC)"
    "REMCTL_PERL_FLAGS='--prefix=$(out)'"
    "REMCTL_PYTHON_INSTALL='--prefix=$(out)'"
  ];

  checkTarget = "check-local";

  meta = with lib; {
    description = "Remote execution tool";
    homepage = "https://www.eyrie.org/~eagle/software/remctl";
    mainProgram = "remctl";
    license = licenses.mit;
    teams = [ teams.deshaw ];
  };
})
