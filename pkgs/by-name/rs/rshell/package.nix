{
  lib,
  python3Packages,
  fetchPypi,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rshell";
  version = "0.0.36";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-SmbYNSB0eVUOWdDdPoMAPQTE7KeKTkklD4h+0t1LC/U=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    pyserial
    pyudev
  ];

  nativeCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://github.com/dhylands/rshell";
    description = "Remote Shell for MicroPython";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ c0deaddict ];
    mainProgram = "rshell";
  };
})
