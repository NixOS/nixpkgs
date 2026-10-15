{
  lib,
  python3Packages,
  fetchPypi,
  fetchpatch2,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mpy-utils";
  version = "0.1.13";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-die8hseaidhs9X7mfFvV8C8zn0uyw08gcHNqmjl+2Z4=";
  };

  patches = [
    # https://github.com/nickzoic/mpy-utils/pull/20
    (fetchpatch2 {
      name = "use-mfusepy.patch";
      url = "https://github.com/nickzoic/mpy-utils/commit/1513b4dc1096bd8861792cd13abafd2342fb5510.patch?full_index=1";
      hash = "sha256-ZgSEP+4yJf/0itApSmVh/hSqW10Ty+/kOjxg+XJsnn4=";
    })
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    mfusepy
    pyserial
  ];

  # Skip mpy_utils.replfuseops: importing it loads libfuse via ctypes, which
  # requires macFUSE on Darwin and is not available in the build sandbox.
  pythonImportsCheck = [
    "mpy_utils"
    "mpy_utils.replcontrol"
  ];

  meta = {
    description = "MicroPython development utility programs";
    homepage = "https://github.com/nickzoic/mpy-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aciceri ];
  };
})
