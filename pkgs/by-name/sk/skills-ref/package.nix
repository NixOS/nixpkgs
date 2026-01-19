{ fetchFromGitHub, python3Packages }:
python3Packages.buildPythonApplication {
  pname = "skills-ref";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "agentskills";
    repo = "agentskills";
    rev = "main";
    hash = "sha256-nZLgAd+ixQtWknKew5M9N1xr8Bo1xbTmPFSvxcYcgS4=";
  };

  sourceRoot = "source/skills-ref";

  pyproject = true;
  build-system = [
    python3Packages.hatchling
  ];

  propagatedBuildInputs = [
    python3Packages.click
    python3Packages.strictyaml
  ];
}
