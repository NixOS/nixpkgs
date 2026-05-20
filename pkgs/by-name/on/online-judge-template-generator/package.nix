{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "online-judge-template-generator";
  version = "4.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "online-judge-tools";
    repo = "template-generator";
    rev = "v${version}";
    sha256 = "sha256-cS1ED1a92fEFqy6ht8UFjxocWIm35IA/VuaPSLsdlqg=";
  };

  propagatedBuildInputs = [
    python3Packages.appdirs
    python3Packages.beautifulsoup4
    python3Packages.colorlog
    python3Packages.mako
    python3Packages.online-judge-api-client
    python3Packages.online-judge-tools
    python3Packages.ply
    python3Packages.pyyaml
    python3Packages.requests
    python3Packages.setuptools
    python3Packages.toml
  ];

  # Needs internet to run tests
  doCheck = false;

  meta = {
    description = "Analyze problems of competitive programming and automatically generate boilerplate";
    homepage = "https://github.com/online-judge-tools/template-generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sei40kr ];
  };
}
