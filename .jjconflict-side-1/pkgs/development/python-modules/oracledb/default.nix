{
  lib,
  buildPythonPackage,
  cryptography,
  cython,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "oracledb";
  version = "26.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "python-oracledb";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-GfhxrDpDn8iInnaMZ/s2EealifpxSNsda3NuZ4ZeROE=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    cryptography
    typing-extensions
  ];

  # Checks need an Oracle database
  doCheck = false;

  pythonImportsCheck = [ "oracledb" ];

  meta = {
    description = "Python driver for Oracle Database";
    homepage = "https://oracle.github.io/python-oracledb";
    changelog = "https://github.com/oracle/python-oracledb/blob/${finalAttrs.src.tag}/doc/src/release_notes.rst";
    license = with lib.licenses; [
      asl20 # and or
      upl
    ];
    maintainers = with lib.maintainers; [ harvidsen ];
  };
})
