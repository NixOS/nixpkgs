{
  catch2,
  cmake,
  eigen,
  fetchFromGitHub,
  lib,
  osqp,
  stdenv,
  valgrind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osqp-eigen";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "gbionics";
    repo = "osqp-eigen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/9M7DufsgjlG4UbBfi64FQsMms06OsljZP2C9uCQe7w=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" true)
    (lib.cmakeBool "OSQPEIGEN_RUN_Valgrind_tests" stdenv.hostPlatform.isLinux)
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    eigen
    osqp
  ];
  checkInputs = [ catch2 ];
  nativeCheckInputs = lib.optional stdenv.hostPlatform.isLinux valgrind;

  doCheck = true;

  meta = {
    description = "Simple Eigen-C++ wrapper for OSQP library";
    homepage = "https://github.com/gbionics/osqp-eigen";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
