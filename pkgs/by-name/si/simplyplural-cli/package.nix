{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "simplyplural-cli";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "SiteRelEnby";
    repo = "simplyplural-cli";
    rev = "v0.1.1";
    hash = "sha256-D4w4sBpAbPrquSvUHteEKGMoW7/oRR1leeevKfl5izA=";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.requests
    python3Packages.websockets
  ];

  meta = with lib; {
    description = "A command-line interface for SimplyPlural";
    homepage = "https://github.com/SiteRelEnby/simplyplural-cli";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ oricat ];
  };
}
