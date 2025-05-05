{
  lib,
  absl-py,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  fpylll,
  gmpy,
  protobuf,
  pybind11,
  pytestCheckHook,
  pythonOlder,
  scipy,
  sympy,
}:

buildPythonPackage {
  pname = "paranoid-crypto";
  version = "unstable-20220819";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "paranoid_crypto";
    # https://github.com/google/paranoid_crypto/issues/11
    rev = "8abccc1619748b93979d1c26234b90d26e88a12e";
    hash = "sha256-4yF7WAFAGGhvWTV/y5dGVA/+9r1dqrXU/0/6Edgw3ow=";
  };

  nativeBuildInputs = [
    protobuf
    pybind11
  ];

  propagatedBuildInputs = [
    absl-py
    cryptography
    gmpy
    scipy
    sympy
    protobuf
  ];

  nativeCheckInputs = [
    fpylll
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "protobuf==3.20.*" "protobuf"
  '';

  disabledTestPaths = [
    # Import issue
    "paranoid_crypto/lib/randomness_tests/"
  ];

  pythonImportsCheck = [ "paranoid_crypto" ];

  meta = with lib; {
    description = "Library contains checks for well known weaknesses on cryptographic artifacts";
    homepage = "https://github.com/google/paranoid_crypto";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
