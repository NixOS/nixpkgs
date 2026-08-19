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

  postPatch =
    # upstream hardcodes a placeholder version which does not track the Ceph release
    ''
      substituteInPlace setup.py \
        --replace-fail \
          "version='1.0.0'" \
          "version='${finalAttrs.version}'"
    '';

  build-system = with ceph-python.pkgs; [
    setuptools
  ];

  dependencies = with ceph-python.pkgs; [
    pyyaml
  ];

  pythonImportsCheck = [ "ceph" ];

  nativeCheckInputs = with ceph-python.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    # requires network access
    "test_valid_addr"
  ];

  meta = ceph-meta "Ceph common module for code shared by manager modules";
})
