{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "peru";
  version = "1.3.3";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "buildinspace";
    repo = "peru";
    rev = version;
    sha256 = "FCyR14jcFjI6epoFPNVyFZ4k1URZ1NraX1+ajVcCQ2A=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pyyaml
    docopt
  ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "peru" ];

  meta = {
    homepage = "https://github.com/buildinspace/peru";
    description = "Tool for including other people's code in your projects";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "peru";
  };

}
