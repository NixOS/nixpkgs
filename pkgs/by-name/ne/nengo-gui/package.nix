{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "nengo-gui";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nengo";
    repo = "nengo-gui";
    tag = "v${version}";
    hash = "sha256-nm5rHXKTzVxrhEJ/ajEFC7yMzYicn+5ubeB2fHhoLys=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ nengo ];

  # selenium based tests don't seem to be working
  doCheck = false;

  meta = with lib; {
    description = "Nengo interactive visualizer";
    homepage = "https://nengo.ai/";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ arjix ];
  };
}
