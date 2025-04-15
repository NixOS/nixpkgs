{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-common";
  # nixpkgs-update: no auto update
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-common";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mywJ1FPCfXvZCJoonuwhXyjf+W/RvtqFl9v64cJoKrc=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags =
    [
      "-DBUILD_SHARED_LIBS=ON"
    ]
    ++ lib.optionals stdenv.hostPlatform.isRiscV [
      "-DCMAKE_C_FLAGS=-fasynchronous-unwind-tables"
    ];

  # aws-c-common misuses cmake modules, so we need
  # to manually add a MODULE_PATH to its consumers
  setupHook = ./setup-hook.sh;

  # Prevent the execution of tests known to be flaky.
  preCheck =
    let
      ignoreTests = [
        "promise_test_multiple_waiters"
      ];
    in
    ''
      cat <<EOW >CTestCustom.cmake
      SET(CTEST_CUSTOM_TESTS_IGNORE ${toString ignoreTests})
      EOW
    '';

  doCheck = true;

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "AWS SDK for C common core";
    homepage = "https://github.com/awslabs/aws-c-common";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      orivej
      r-burns
    ];
  };
})
