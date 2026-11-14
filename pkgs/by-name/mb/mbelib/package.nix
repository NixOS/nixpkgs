{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mbelib";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "szechyjs";
    repo = "mbelib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LmYCOUTnykV9mAgxMH5uFP5CscfOcfb+Pr4/h5w9y2w=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10") ];

  doCheck = true;

  meta = {
    description = "P25 Phase 1 and ProVoice vocoder";
    homepage = "https://github.com/szechyjs/mbelib";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.aciceri ];
  };
})
