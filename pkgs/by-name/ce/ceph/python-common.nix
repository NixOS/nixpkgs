{
  ceph-python,
  ceph-meta,
  ceph-src,
}:

ceph-python.pkgs.buildPythonPackage {
  pname = "ceph-common";
  inherit (ceph-src) version;
  src = ceph-src;

  pyproject = true;

  sourceRoot = "${ceph-src.name}/src/python-common";

  build-system = with ceph-python.pkgs; [
    setuptools
  ];

  dependencies = with ceph-python.pkgs; [
    pyyaml
  ];

  nativeCheckInputs = with ceph-python.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    # requires network access
    "test_valid_addr"
  ];

  meta = ceph-meta "Ceph common module for code shared by manager modules";
}
