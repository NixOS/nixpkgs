{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "roboenum";
  version = "0-unstable-2025-06-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "QTShade";
    repo = "RoboEnum";
    # https://github.com/QTShade/RoboEnum/issues/2
    rev = "1401cfe41486c982cc38a2c2401689bd25963e1a";
    hash = "sha256-T4KVsMKxqrblznZhAeR+OV5xX5nCX/7Umf/xRK++Fqw=";
  };

  sourceRoot = "${src.name}/${pname}";

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    colorama
    httpx
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "roboenum" ];

  meta = {
    description = "Robots.txt Web Recon and Enumeration Tool";
    homepage = "https://github.com/QTShade/RoboEnum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "roboenum";
  };
}
