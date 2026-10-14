{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jitterentropy";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-library";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sJWgPx3GbvnBBVlCML/eRtUoMXux38tpWi1ZKhz41xY=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [
    "out"
    "dev"
  ];

  # disable internal timer thread and only use processor high-resolution timer
  # this also fixes the rng-tools build
  cmakeFlags = [
    "-DINTERNAL_TIMER=OFF"
  ];

  # this package internally compiles without optimization by choice,
  # as it introduces more execution time jitter, therefore disable fortify.
  hardeningDisable = [
    "fortify"
    "fortify3"
  ];

  meta = {
    description = "Provides a noise source using the CPU execution timing jitter";
    homepage = "https://github.com/smuellerDD/jitterentropy-library";
    changelog = "https://github.com/smuellerDD/jitterentropy-library/raw/v${finalAttrs.version}/CHANGES.md";
    license = with lib.licenses; [
      bsd3 # OR
      gpl2Only
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      johnazoidberg
      thillux
    ];
  };
})
