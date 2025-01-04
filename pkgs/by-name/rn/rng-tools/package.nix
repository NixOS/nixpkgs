{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  pkg-config,
  psmisc,
  argp-standalone,
  openssl,
  libcap,
  jitterentropy,
  withJitterEntropy ? true,
  # WARNING: DO NOT USE BEACON GENERATED VALUES AS SECRET CRYPTOGRAPHIC KEYS
  # https://www.nist.gov/programs-projects/nist-randomness-beacon
  curl,
  jansson,
  libxml2,
  withNistBeacon ? false,
  libp11,
  opensc,
  withPkcs11 ? true,
  rtl-sdr,
  withRtlsdr ? true,
  withQrypt ? false,
}:

stdenv.mkDerivation rec {
  pname = "rng-tools";
  version = "6.17";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wqJvLvxmNG2nb5P525w25Y8byUUJi24QIHNJomCKeG8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];

  configureFlags = [
    (lib.enableFeature (withJitterEntropy) "jitterentropy")
    (lib.withFeature (withNistBeacon) "nistbeacon")
    (lib.withFeature (withPkcs11) "pkcs11")
    (lib.withFeature (withRtlsdr) "rtlsdr")
    (lib.withFeature (withQrypt) "qrypt")
  ];

  buildInputs =
    [
      openssl
      libcap
    ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [ argp-standalone ]
    ++ lib.optionals withJitterEntropy [ jitterentropy ]
    ++ lib.optionals withNistBeacon [
      curl
      jansson
      libxml2
    ]
    ++ lib.optionals withPkcs11 [
      libp11
      libp11.passthru.openssl
    ]
    ++ lib.optionals withRtlsdr [ rtl-sdr ]
    ++ lib.optionals withQrypt [
      curl
      jansson
    ];

  enableParallelBuilding = true;

  makeFlags =
    [
      "AR:=$(AR)" # For cross-compilation
    ]
    ++ lib.optionals withPkcs11 [
      "PKCS11_ENGINE=${opensc}/lib/opensc-pkcs11.so" # Overrides configure script paths
    ];

  doCheck = true;
  preCheck = ''
    patchShebangs tests/*.sh
    export RNGD_JITTER_TIMEOUT=10
  '';
  # After updating to jitterentropy 3.4.1 jitterentropy initialization seams
  # to have increased. On some system rng-tools fail therefore to initialize the
  # jitterentropy entropy source. You can increase the init timeout with a command-line
  # option (-O jitter:timeout:SECONDS). The environment variable above only has effect
  # for the test cases.
  # Patching the timeout to a larger value was declined upstream,
  # see (https://github.com/nhorman/rng-tools/pull/178).
  nativeCheckInputs = [ psmisc ]; # rngtestjitter.sh needs killall

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    set -o pipefail
    $out/bin/rngtest --version | grep $version
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Random number generator daemon";
    homepage = "https://github.com/nhorman/rng-tools";
    changelog = "https://github.com/nhorman/rng-tools/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      johnazoidberg
      c0bw3b
    ];
  };
}
