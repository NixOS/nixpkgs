{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "epr";
  version = "2.4.13";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "wustho";
    repo = "epr";
    rev = "v${version}";
    sha256 = "sha256-1qsqYlqGlCRhl7HINrcTDt5bGlb7g5PmaERylT+UvEg=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  meta = with lib; {
    description = "CLI Epub Reader";
    mainProgram = "epr";
    homepage = "https://github.com/wustho/epr";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
