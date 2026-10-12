# One of the four libraries reproto needs, private to it (spec 0411 S6):
# built from reproto's own source, at its version, with its vendored Cargo
# dependencies, so that one update moves all five.
{
  lib,
  buildPythonPackage,
  rustPlatform,
  protobuf,
  pytestCheckHook,
  src,
  version,
  cargoDeps,
}:

buildPythonPackage {
  pname = "fdp-scan";
  inherit src version cargoDeps;
  pyproject = true;
  __structuredAttrs = true;

  buildAndTestSubdir = "fdp-scan-pyo3";

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ];

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeCheckInputs = [
    protobuf
    pytestCheckHook
  ];

  enabledTestPaths = [ "fdp-scan-pyo3/tests" ];

  pythonImportsCheck = [ "fdp_scan_lib" ];

  meta = {
    description = "Python bindings to the scan for protobuf descriptors embedded in binaries";
    homepage = "https://github.com/douzebis/prototools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
  };
}
