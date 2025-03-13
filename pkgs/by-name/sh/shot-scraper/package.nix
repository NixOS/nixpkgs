{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "shot-scraper";
  version = "1.7";
  format = "setuptools";

  disabled = python3.pkgs.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "shot-scraper";
    tag = version;
    hash = "sha256-MEPixHDiOc5NaPuIKUueGXV5A9K7SFj/WEKb4gen0lI=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    click-default-group
    playwright
    pyyaml
  ];

  # skip tests due to network access
  doCheck = false;

  pythonImportsCheck = [
    "shot_scraper"
  ];

  meta = with lib; {
    description = "Command-line utility for taking automated screenshots of websites";
    homepage = "https://github.com/simonw/shot-scraper";
    changelog = "https://github.com/simonw/shot-scraper/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick ];
    mainProgram = "shot-scraper";
  };
}
