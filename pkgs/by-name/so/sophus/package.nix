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
  version = "1.22.10";

  src = fetchFromGitHub {
    owner = "strasdat";
    repo = "Sophus";
    rev = finalAttrs.version;
    hash = "sha256-TNuUoL9r1s+kGE4tCOGFGTDv1sLaHJDUKa6c9x41Z7w=";
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
