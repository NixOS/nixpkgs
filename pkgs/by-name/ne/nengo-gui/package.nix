{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "nengo-gui";
  version = "0.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nengo";
    repo = "nengo-gui";
    tag = "v${version}";
    sha256 = "sha256-nm5rHXKTzVxrhEJ/ajEFC7yMzYicn+5ubeB2fHhoLys=";
  };

  propagatedBuildInputs = with python3Packages; [ nengo ];

  # checks req missing:
  #   pyimgur
  doCheck = false;

  meta = {
    description = "Nengo interactive visualizer";
    homepage = "https://nengo.ai/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
  };
}
