{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pffft";
  version = "1.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "marton78";
    repo = "pffft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+efWiBrJzC188tDSPHMARRDArzx/4E8GYPMfDHAND8k=";
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Pretty Fast FFT (PFFFT) library";
    homepage = "https://github.com/marton78/pffft";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
