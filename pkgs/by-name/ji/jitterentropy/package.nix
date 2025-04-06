{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "jitterentropy";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-library";
    rev = "v${version}";
    hash = "sha256-A1Y+7CqzoQ6xoTwWU8gfq+dYJ+PiIpqtOOZSL0uVby4=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [
    "out"
    "dev"
  ];

  hardeningDisable = [ "fortify" ]; # avoid warnings

  meta = {
    description = "Provides a noise source using the CPU execution timing jitter";
    homepage = "https://github.com/smuellerDD/jitterentropy-library";
    changelog = "https://github.com/smuellerDD/jitterentropy-library/raw/v${version}/CHANGES.md";
    license = with lib.licenses; [
      bsd3 # OR
      gpl2Only
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      johnazoidberg
      c0bw3b
    ];
  };
}
