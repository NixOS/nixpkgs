{
  lib,

  stdenv,
  fetchFromGitLab,

  # nativeBuildInputs
  cmake,

  # nativeCheckInputs
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigen";
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    tag = finalAttrs.version;
    hash = "sha256-8TW1MUXt2gWJmu5YbUWhdvzNBiJ/KIVwIRf2XuVZeqo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "EIGEN_LEAVE_TEST_IN_ALL_TARGET" true) # Build tests in parallel
  ];

  doCheck = true;

  meta = {
    homepage = "https://eigen.tuxfamily.org";
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.unix;
  };
})
