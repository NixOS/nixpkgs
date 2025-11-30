{
  lib,
  python3,
  fetchFromGitHub,
  gitUpdater,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cewler";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roys";
    repo = "cewler";
    rev = "v${version}";
    hash = "sha256-9P8vFacbw0pgthYqJY/aPuV39VQuMAA8o7yJ8HkD7RQ=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pypdf
    rich
    scrapy
    tld
    twisted
  ];

  pythonRelaxDeps = true;
  # Tests require network access
  doCheck = false;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Custom Word List generator Redefined";
    mainProgram = "cewler";
    homepage = "https://github.com/roys/cewler";
    license = licenses.cc-by-nc-40;
    maintainers = with maintainers; [ emilytrau ];
  };
}
