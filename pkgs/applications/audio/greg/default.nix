{ lib, fetchFromGitHub, pythonPackages }:

with pythonPackages; buildPythonApplication rec {
  pname = "greg";
  version = "0.4.8";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "manolomartinez";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-o4+tXVJTgT52JyJOC+Glr2cvZjbTaZL8TIsmz+A4vE4=";
  };

  propagatedBuildInputs = [ setuptools feedparser ];

  meta = with lib; {
    homepage = "https://github.com/manolomartinez/greg";
    description = "Command-line podcast aggregator";
    mainProgram = "greg";
    license = licenses.gpl3;
    maintainers = with maintainers; [ edwtjo ];
  };
}
