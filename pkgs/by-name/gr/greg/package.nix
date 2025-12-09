{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "greg";
  version = "0.4.8";
  format = "setuptools";

  disabled = !python3Packages.isPy3k;

  src = fetchFromGitHub {
    owner = "manolomartinez";
    repo = "greg";
    tag = "v${version}";
    hash = "sha256-o4+tXVJTgT52JyJOC+Glr2cvZjbTaZL8TIsmz+A4vE4=";
  };

  propagatedBuildInputs = [
    python3Packages.setuptools
    python3Packages.feedparser
  ];

  meta = {
    homepage = "https://github.com/manolomartinez/greg";
    description = "Command-line podcast aggregator";
    mainProgram = "greg";
    license = lib.licenses.gpl3;
  };
}
