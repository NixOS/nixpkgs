{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "instaloader";
  version = "4.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "instaloader";
    repo = "instaloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6gk+BqWJ2cBQaQieyo/c0lgiRi4q07LMofGqa5Velog=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.requests
    python3Packages.sphinx
  ];

  pythonImportsCheck = [ "instaloader" ];

  meta = {
    homepage = "https://instaloader.github.io/";
    description = "Download pictures (or videos) along with their captions and other metadata from Instagram";
    maintainers = with lib.maintainers; [ creator54 ];
    license = lib.licenses.mit;
    mainProgram = "instaloader";
  };
})
