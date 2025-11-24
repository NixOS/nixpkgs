{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "hashid";
  version = "3.1.4-unstable-2015-03-17";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "psypanda";
    repo = "hashID";
    rev = "7e8473a823060e56d4b6090a98591e252bd9505e";
    hash = "sha256-R2r/UYRcHbpfOz/XqtSUIpd826eT1Erfo7frAiArT34=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  meta = with lib; {
    description = "Software to identify the different types of hashes";
    homepage = "https://github.com/psypanda/hashID";
    mainProgram = "hashid";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
  };
}
