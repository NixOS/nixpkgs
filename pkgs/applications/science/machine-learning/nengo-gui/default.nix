{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "nengo-gui";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "nengo";
    repo = "nengo-gui";
    rev = "v${version}";
    sha256 = "1awb0h2l6yifb77zah7a4qzxqvkk4ac5fynangalidr10sk9rzk3";
  };

  propagatedBuildInputs = with python3Packages; [ nengo ];

  # checks req missing:
  #   pyimgur
  doCheck = false;

  meta = with lib; {
    description = "Nengo interactive visualizer";
    homepage    = "https://nengo.ai/";
    license     = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ arjix ];
  };
}
