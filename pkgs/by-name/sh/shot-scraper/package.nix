{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "shot-scraper";
  version = "1.4";
  format = "setuptools";

  disabled = python3.pkgs.pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hPzOwvTQAFs9IQRkq/uw+pHv5ZP5XU3Zn605SL8udPA=";
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
    changelog = "https://github.com/simonw/shot-scraper/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick ];
    mainProgram = "shot-scraper";
  };
}
