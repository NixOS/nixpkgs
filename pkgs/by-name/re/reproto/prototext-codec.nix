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
  pname = "prototext-codec";
  inherit src version cargoDeps;
  pyproject = true;
  __structuredAttrs = true;

  buildAndTestSubdir = "prototext-pyo3";

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ];

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeCheckInputs = [
    protobuf
    pytestCheckHook
  ];

  enabledTestPaths = [ "prototext-pyo3/tests" ];

  pythonImportsCheck = [ "prototext_codec_lib" ];

  meta = {
    description = "Python bindings to prototext's lossless protobuf codec";
    homepage = "https://github.com/douzebis/prototools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
  };
}
