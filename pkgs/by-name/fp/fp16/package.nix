{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fp16";
  version = "0-unstable-2024-20-06";

  src = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "FP16";
    rev = "98b0a46bce017382a6351a19577ec43a715b6835";
    sha256 = "sha256-aob776ZGjnH4k/xfsdIcN9+wiuDreUoRBpyzrWGuxKk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "FP16_BUILD_TESTS" false)
    (lib.cmakeBool "FP16_BUILD_BENCHMARKS" false)
    (lib.cmakeBool "FP16_USE_SYSTEM_LIBS" true)
  ];

  doCheck = true;

  meta = {
    description = "Header-only library for conversion to/from half-precision floating point formats";
    homepage = "https://github.com/Maratyszcza/FP16";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
