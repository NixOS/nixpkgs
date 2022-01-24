{ lib, fetchFromGitHub, pythonPackages }:

with pythonPackages; buildPythonApplication rec {
  pname = "greg";
  version = "0.4.7";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "manolomartinez";
    repo = pname;
    rev = "v" + version;
    sha256 = "0bdzgh2k1ppgcvqiasxwp3w89q44s4jgwjidlips3ixx1bzm822v";
  };

  propagatedBuildInputs = [ setuptools feedparser ];

  meta = with lib; {
    homepage = "https://github.com/manolomartinez/greg";
    description = "A command-line podcast aggregator";
    license = licenses.gpl3;
    maintainers = with maintainers; [ edwtjo ];
  };
}
