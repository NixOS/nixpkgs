{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  versionCheckHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "caringcaribou";
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CaringCaribou";
    repo = "caringcaribou";
    tag = finalAttrs.version;
    hash = "sha256-x6yDJtyhzUpRLfmXOHkC+IjIcO+oUBrJbNooBX+g+wc=";
  };

  patches = [
    # Backport pyproject.toml with entry points
    (fetchpatch {
      url = "https://github.com/CaringCaribou/caringcaribou/commit/8ee77ef127f26ae4121ceb2706bbb49513d39785.patch";
      hash = "sha256-bVbCORfKciojJkVmnB5vmVS/k4T9tDuthqi5wyAuOXg=";
    })
    (fetchpatch {
      url = "https://github.com/CaringCaribou/caringcaribou/commit/f05c5cec0e643654587fd346378be2ad69ef4d17.patch";
      hash = "sha256-+XyTpB1HGW1/rzUfn8FuKeOMza5JU11iFWfuzpOzO5c=";
    })

    # Backport fix that removes the deprecated pkg_resources library usage
    (fetchpatch {
      url = "https://github.com/CaringCaribou/caringcaribou/commit/93d9518df4f496efccefd8d637802b99be9fa83c.patch";
      hash = "sha256-bknn5HfkyU5iDekl8Tq5sdASQx6wXEi+Yhfa4L11vio=";
    })
  ];

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    python-can
    doipclient
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  disabledTestPaths = [
    # can.exceptions.CanInterfaceNotImplementedError: Unknown interface type "None"
    "caringcaribou/tests/test_iso_15765_2.py"
    "caringcaribou/tests/test_iso_14229_1.py"
    "caringcaribou/tests/test_module_uds.py"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Friendly automatic security exploration tool";
    homepage = "https://github.com/CaringCaribou/caringcaribou";
    changelog = "https://github.com/CaringCaribou/caringcaribou/releases/tag/${finalAttrs.version}";
    mainProgram = "caringcaribou";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      mana-byte
      RossSmyth
    ];
  };
})
