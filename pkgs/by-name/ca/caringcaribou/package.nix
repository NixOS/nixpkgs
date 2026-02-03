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
  ];

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    python-can
    setuptools
    doipclient
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "A friendly automatic security exploration tool";
    license = lib.licenses.gpl3Only;
    maintainer = lib.maintainers.RossSmyth;
  };
})
