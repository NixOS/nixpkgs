{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "jitterentropy";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-library";
    rev = "v${version}";
    hash = "sha256-A7a0kg9JRiNNKJbLJu5Fbu6ZgCwv3+3oDhZr3jwNXmM=";
  };

  patches = [
    # cmake 4 compatibility
    (fetchpatch {
      url = "https://github.com/smuellerDD/jitterentropy-library/commit/047beb1bf9ef7a14e63f3e4f2d4e79f673baa7ec.patch";
      hash = "sha256-m/cfI7s7sdjkZjkKL/w/rNZzP/t3eimbVryMW5+crw4=";
    })
  ];

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
