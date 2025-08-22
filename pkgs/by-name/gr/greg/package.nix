{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "greg";
  version = "0.4.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "manolomartinez";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-o4+tXVJTgT52JyJOC+Glr2cvZjbTaZL8TIsmz+A4vE4=";
  };

  propagatedBuildInputs = with python3Packages; [
    setuptools
    feedparser
  ];

  meta = with lib; {
    homepage = "https://github.com/manolomartinez/greg";
    description = "Command-line podcast aggregator";
    mainProgram = "greg";
    license = licenses.gpl3;
    maintainers = with maintainers; [ edwtjo ];
  };
}
