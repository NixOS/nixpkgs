{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "instaloader";
  version = "4.15a1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "instaloader";
    repo = "instaloader";
    tag = "v${version}";
    hash = "sha256-myrCZIus9psR7dw6yVv730JSe0XyXEz9TR/UWgXCVi0=";
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
}
