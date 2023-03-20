{ lib, fetchFromGitLab, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "tuir";
  version = "1.29.0";

  src = fetchFromGitLab {
    owner = "ajak";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fqp6bvq8kzdsf3nna4mn1phdcixpx76bya43xrivxjbzsfl59ib";
  };

  # Tests try to access network
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  nativeCheckInputs = [ coverage coveralls docopt mock pylint pytest vcrpy ];

  propagatedBuildInputs = [ beautifulsoup4 decorator kitchen requests six ];

  meta = with lib; {
    description = "Browse Reddit from your Terminal (fork of rtv)";
    homepage = "https://gitlab.com/ajak/tuir/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne matthiasbeyer ];
  };
}
