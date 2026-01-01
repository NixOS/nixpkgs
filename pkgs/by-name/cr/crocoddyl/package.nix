{
  blas,
  cmake,
  doxygen,
  example-robot-data,
  fetchFromGitHub,
<<<<<<< HEAD
  ffmpeg,
=======
  fetchpatch,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ipopt,
  lapack,
  lib,
  pinocchio,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crocoddyl";
<<<<<<< HEAD
  version = "3.2.0";
=======
  version = "3.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "crocoddyl";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-EYvakM81Ot/AtXElJbcQNo7IydBtRgy+8a0cY06CzQ8=";
  };

=======
    hash = "sha256-m7UiCa8ydjsAIhsFiShTi3/JaKgq2TCQ1XYAMyTNg1U=";
  };

  patches = [
    # ref. https://github.com/loco-3d/crocoddyl/pull/1440 merged upstream
    (fetchpatch {
      name = "add-missing-include.patch";
      url = "https://github.com/loco-3d/crocoddyl/commit/6994bea7bb3ae6027f5b611ef1635768538150fd.patch";
      hash = "sha256-XbQKRWpWm5Rk4figoA2swId4Pz2xKDpU4NFP46p8WO0=";
    })
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  propagatedBuildInputs = [
    blas
    ipopt
    lapack
    example-robot-data
    pinocchio
  ];

<<<<<<< HEAD
  checkInputs = [
    ffmpeg
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cmakeFlags = [
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
  ];

  prePatch = ''
    substituteInPlace \
      examples/CMakeLists.txt \
      examples/log/check_logfiles.sh \
      --replace-fail /bin/bash ${stdenv.shell}
  '';

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Crocoddyl optimal control library";
    homepage = "https://github.com/loco-3d/crocoddyl";
    changelog = "https://github.com/loco-3d/crocoddyl/blob/devel/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      nim65s
      wegank
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Crocoddyl optimal control library";
    homepage = "https://github.com/loco-3d/crocoddyl";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      nim65s
      wegank
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
