{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cryptop";
  version = "0.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "huwwp";
    repo = "cryptop";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-lrHTtTQJ9Zuspt+LRT9WjmCruhwms6FUM3EFo6PZ26A=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    setuptools
    requests
    requests-cache
  ];

  # No tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/huwwp/cryptop";
    description = "Command line Cryptocurrency Portfolio";
    license = lib.licenses.mit;
    mainProgram = "cryptop";
  };
})
