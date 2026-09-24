{
  lib,
  stdenv,
  eigen,
  fmt,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sophus";
  version = "1.24.6";

  src = fetchFromGitHub {
    owner = "strasdat";
    repo = "Sophus";
    rev = finalAttrs.version;
    hash = "sha256-k5t3kSUrH6B1f60dtqq3Ai4R4D2h+Ld+6Cpljl/AN0w=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    eigen
    fmt
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SOPHUS_TESTS" false)
    (lib.cmakeBool "BUILD_SOPHUS_EXAMPLES" false)
  ];

  meta = {
    description = "C++ implementation of Lie Groups using Eigen";
    homepage = "https://github.com/strasdat/Sophus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      locochoco
      acowley
    ];
    platforms = lib.platforms.all;
  };
})
