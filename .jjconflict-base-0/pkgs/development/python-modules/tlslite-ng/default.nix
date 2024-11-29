{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ecdsa,
  hypothesis,
  pythonAtLeast,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "tlslite-ng";
  version = "0.8.0b1-unstable-2024-06-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tlsfuzzer";
    repo = "tlslite-ng";
    rev = "4d2c6b8fc8d14bb5c90c8360bdb6f617e8e38591";
    hash = "sha256-VCQjxZIs4rzlFrIakXI7YeLz7Ws9WRf8zGPcSryO9Ko=";
  };

  build-system = [ setuptools ];

  dependencies = [ ecdsa ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  # This file imports asyncore which is removed in 3.12
  disabledTestPaths = lib.optionals (pythonAtLeast "3.12") [
    "tlslite/integration/tlsasyncdispatchermixin.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/tlsfuzzer/tlslite-ng/releases/tag/v${version}";
    description = "Pure python implementation of SSL and TLS";
    homepage = "https://github.com/tlsfuzzer/tlslite-ng";
    license = licenses.lgpl21Only;
    maintainers = [ ];
  };
}
