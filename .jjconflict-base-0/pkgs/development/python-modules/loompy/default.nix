{
  lib,
  fetchPypi,
  buildPythonPackage,
  h5py,
  numpy,
  scipy,
  numba,
  click,
  numpy-groupies,
  setuptools,
  pytestCheckHook,
}:
let
  finalAttrs = {
    pname = "loompy";
    version = "3.0.7";
    pyproject = true;

    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-tc33tUc0xr7ToYHRGUevcK8sbg3K3AL9Docd8jL6qPQ=";
    };

    build-system = [ setuptools ];

    dependencies = [
      h5py
      numpy
      scipy
      numba
      click
      numpy-groupies
    ];

    nativeCheckInputs = [ pytestCheckHook ];

    # Deprecated numpy attributes access
    disabledTests = [
      "test_scan_with_default_ordering"
      "test_get"
    ];

    pythonImportsCheck = [ "loompy" ];

    meta = {
      changelog = "https://github.com/linnarsson-lab/loompy/releases";
      description = "Python implementation of the Loom file format";
      homepage = "https://github.com/linnarsson-lab/loompy";
      license = lib.licenses.bsd2;
      maintainers = with lib.maintainers; [ theobori ];
      mainProgram = "loompy";
    };
  };
in
buildPythonPackage finalAttrs
