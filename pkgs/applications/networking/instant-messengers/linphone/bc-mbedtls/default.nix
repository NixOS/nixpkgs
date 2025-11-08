{
  lib,
  stdenv,
  fetchFromGitLab,

  cmake,
  ninja,
  perl, # Project uses Perl for scripting and testing
  python3,
}:
let
  rev = "1d452d3852321cb55c07307cb506b25759134b76";
in
stdenv.mkDerivation {
  pname = "mbedtls";
  # taken from `ChangeLog`
  version = "3.6.1-unstable-2025-08-11";

  src = fetchFromGitLab {
    inherit rev;

    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "mbedtls";
    sha256 = "sha256-jQpRn2F21sPKKAiaqsUvaKyuR80AnedG/hAyiNamKjc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    perl
    python3
  ];

  strictDeps = true;

  # trivialautovarinit on clang causes test failures
  hardeningDisable = lib.optional stdenv.cc.isClang "trivialautovarinit";

  cmakeFlags = [
    # tests don't compile, due to how BC sets up threading
    "-DENABLE_TESTING=OFF"
    "-DENABLE_PROGRAMS=OFF"

    "-DUSE_SHARED_MBEDTLS_LIBRARY=${if stdenv.hostPlatform.isStatic then "off" else "on"}"

    # Avoid a dependency on jsonschema and jinja2 by not generating source code
    # using python. In releases, these generated files are already present in
    # the repository and do not need to be regenerated. See:
    # https://github.com/Mbed-TLS/mbedtls/releases/tag/v3.3.0 below "Requirement changes".
    "-DGEN_FILES=off"
  ];

  # Parallel checking causes test failures
  # https://github.com/Mbed-TLS/mbedtls/issues/4980
  enableParallelChecking = false;

  meta = {
    homepage = "https://gitlab.linphone.org/BC/public/external/mbedtls";
    changelog = "https://gitlab.linphone.org/BC/public/external/mbedtls/-/blob/${rev}/ChangeLog";
    description = "Portable cryptographic and TLS library, formerly known as PolarSSL (Linphone fork)";
    license = with lib.licenses; [
      asl20 # or
      gpl2Plus
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ naxdy ];
  };
}
