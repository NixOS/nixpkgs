{
  ceph-python,
  ceph-meta,
  ceph-src,
}:

ceph-python.pkgs.buildPythonPackage (finalAttrs: {
  pname = "ceph";
  inherit (ceph-src) version;
  src = ceph-src;

  pyproject = true;
  __structuredAttrs = true;

  sourceRoot = "${ceph-src.name}/src/python-common";

  build-system = with ceph-python.pkgs; [
    setuptools
  ];

  dependencies = with ceph-python.pkgs; [
    pyyaml
    cryptography
  ];

  pythonImportsCheck = [ "ceph" ];

  nativeCheckInputs = with ceph-python.pkgs; [
    pytestCheckHook
  ];

  nativeBuildInputs = with ceph-python.pkgs; [
    pyprojectVersionPatchHook
  ];

  disabledTests = [
    # requires network access
    "test_valid_addr"
  ];

  meta = ceph-meta "Ceph common module for code shared by manager modules";
})
