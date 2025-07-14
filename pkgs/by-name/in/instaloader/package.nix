{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "instaloader";
  version = "4.14.1";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "instaloader";
    repo = "instaloader";
    tag = "v${version}";
    hash = "sha256-ZGCO5xNUwrQFsSaAiP1yffrkSN+Mxdtrw+Kve0s2t2E=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
  ];

  propagatedBuildInputs = [
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
