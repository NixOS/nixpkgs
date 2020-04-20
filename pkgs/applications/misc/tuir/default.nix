{ lib, fetchFromGitLab, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "tuir";
  version = "1.28.3";

  src = fetchFromGitLab {
    owner = "ajak";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nhpbb0vdngwb0fhlimjgm3wq2s67m4rb3vv920zyllnmfplk0lk";
  };

  # Tests try to access network
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  checkInputs = [ coverage coveralls docopt mock pylint pytest vcrpy ];

  propagatedBuildInputs = [ beautifulsoup4 decorator kitchen requests ];

  meta = with lib; {
    description = "Browse Reddit from your Terminal (fork of rtv)";
    homepage = "https://gitlab.com/ajak/tuir/";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 matthiasbeyer ];
  };
}
