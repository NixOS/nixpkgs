{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "instaloader";
  version = "4.14.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "instaloader";
    repo = "instaloader";
    tag = "v${version}";
    hash = "sha256-q5/lZ+BHnrod0vG/ZJw/5iJRKKaP3Gbns5yaZH0P2rE=";
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
