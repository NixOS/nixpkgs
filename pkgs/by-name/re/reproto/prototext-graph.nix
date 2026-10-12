# One of the four libraries reproto needs, private to it (spec 0411 S6):
# built from reproto's own source, at its version, with its vendored Cargo
# dependencies, so that one update moves all five.
{
  lib,
  buildPythonPackage,
  rustPlatform,
  src,
  version,
  cargoDeps,
}:

buildPythonPackage {
  pname = "prototext-graph";
  inherit src version cargoDeps;
  pyproject = true;
  __structuredAttrs = true;

  buildAndTestSubdir = "prototext-graph-pyo3";

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ];

  build-system = [ rustPlatform.maturinBuildHook ];

  # There are no Python tests
  doCheck = false;

  pythonImportsCheck = [ "prototext_graph_lib" ];

  meta = {
    description = "Python bindings to the prototools scoring graph builder";
    homepage = "https://github.com/douzebis/prototools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
  };
}
