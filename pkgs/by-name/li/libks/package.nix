{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ctestCheckHook,
  pkg-config,
  libuuid,
  openssl,
  libossp_uuid,
  freeswitch,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libks";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "signalwire";
    repo = "libks";
    tag = "v${version}";
    hash = "sha256-cBNNCOm+NcIvozN4Z4XnZWBBqq0LVELVqXubQB4JMTU=";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openwrt/telephony/5ced7ea4fc9bd746273d564bf3c102f253d2182e/libs/libks/patches/01-find-libm.patch";
      sha256 = "1hyrsdxg69d08qzvf3mbrx2363lw52jcybw8i3ynzqcl228gcg8a";
    })
  ];

  dontUseCmakeBuildDir = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libuuid
  ++ lib.optional stdenv.hostPlatform.isDarwin libossp_uuid;

  nativeCheckInputs = [
    ctestCheckHook
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  disabledTests = [
    # Runs into certificate error on aarch64
    # [ERROR] [...] testhttp.c:95    init_ssl [...] SSL ERR: CERT CHAIN FILE ERROR
    "testhttp"

    # Runs into what seems like an overflow / memory corruption in the testing framework on the community runner.
    # Doesn't happen on local ARM hardware, maybe due to unexpectedly high core count?
    "testthreadmutex"
  ];

  # Something seems to go wrong with testwebsock2 when using parallelism
  enableParallelChecking = false;

  passthru = {
    tests.freeswitch = freeswitch;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Foundational support for signalwire C products";
    homepage = "https://github.com/signalwire/libks";
    maintainers = with lib.maintainers; [ misuzu ];
    teams = [ lib.teams.ngi ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
