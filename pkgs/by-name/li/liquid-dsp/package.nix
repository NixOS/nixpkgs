{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  darwin,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "liquid-dsp";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "jgaeddert";
    repo = "liquid-dsp";
    rev = "v${version}";
    sha256 = "sha256-QRCPdngQCpC+o8fCLVoixPsZ25yI1ZEo8ePreC2S0Yk=";
  };

  patches = [
    ./fix-cmake-pc-paths.patch
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
    fixDarwinDylibNames
  ];

  cmakeFlags = [
    # Prevent native cpu arch from leaking into binaries.
    (lib.cmakeBool "ENABLE_SIMD" false)
    (lib.cmakeBool "FIND_SIMD" false)
    # Some build info is included as of 1.8.1. Most of these are not a problem
    # or handled by the build sandbox but the hostname should be stripped.
    (lib.cmakeBool "ENABLE_TIMESTAMPS" false)
  ];

  doCheck = true;

  meta = {
    homepage = "https://liquidsdr.org/";
    description = "Digital signal processing library for software-defined radios";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ iank ];
  };
}
