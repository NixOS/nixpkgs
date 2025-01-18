{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aces-container";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "ampas";
    repo = "aces_container";
    rev = "v${finalAttrs.version}";
    hash = "sha256-luMqXqlJ6UzoawEDmbK38lm3GHosaZm/mFJntBF54Y4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-c++11-narrowing";

  meta = with lib; {
    description = "Reference Implementation of SMPTE ST2065-4";
    homepage = "https://github.com/ampas/aces_container";
    license = licenses.ampas;
    maintainers = with maintainers; [ paperdigits ];
    mainProgram = "aces-container";
    platforms = platforms.all;
  };
})
