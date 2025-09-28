{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "peru";
  version = "1.3.4";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "buildinspace";
    repo = "peru";
    rev = version;
    sha256 = "sha256-ubkDB/McG2Tp3s0K5PbL6QpHbpqRLAUSHa7v+u/n6hI=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pyyaml
    docopt
  ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "peru" ];

  meta = with lib; {
    homepage = "https://github.com/buildinspace/peru";
    description = "Tool for including other people's code in your projects";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "peru";
  };

}
