{
  blasfeo,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  lib,
  llvmPackages,
  python3Packages,
  pythonSupport ? false,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fatrop";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "meco-group";
    repo = "fatrop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vCGix3qYQR9bY9GoIyBMrTNvsMgt0h7TZUye6wlH9H8=";
  };

  patches = lib.optionals pythonSupport [
    # fix python packaging
    # ref. https://github.com/meco-group/fatrop/pull/17
    # this was merged upstream and can be removed on next release
    (fetchpatch {
      url = "https://github.com/meco-group/fatrop/pull/17/commits/22e33c216e47df90dc060686d7d1806233642249.patch";
      hash = "sha256-0/uSHAXVzXVyR+kklQGvraLA6sJbHzUcAp3eEHQK068=";
    })
    (fetchpatch {
      url = "https://github.com/meco-group/fatrop/pull/17/commits/0c03fd9fec95de42976fed1770a15081d0874ee2.patch";
      hash = "sha256-FenQ05rqn9EbU0wDVQQ1OFxSXj1fL/rOFKOcP8t1NwY=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [ blasfeo ]
    ++ lib.optionals pythonSupport [ python3Packages.pybind11 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCS" true)
    (lib.cmakeBool "ENABLE_MULTITHREADING" true)
    (lib.cmakeBool "BUILD_WITH_BLASFEO" false)
    (lib.cmakeBool "WITH_PYTHON" pythonSupport)
    (lib.cmakeBool "WITH_SPECTOOL" false) # this depends on casadi
  ];

  doCheck = true;

  meta = {
    description = "nonlinear optimal control problem solver that aims to be fast, support a broad class of optimal control problems and achieve a high numerical robustness";
    homepage = "https://github.com/meco-group/fatrop";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
