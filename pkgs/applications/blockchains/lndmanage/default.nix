{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "lndmanage";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "bitromortac";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wPr/R+WGACyhv2Qh9JeLJwvr2vQfxpqj2XjEkrRoSX4=";
  };

  propagatedBuildInputs = with python3Packages; [
    cycler
    decorator
    googleapis-common-protos
    grpcio
    grpcio-tools
    kiwisolver
    networkx
    numpy
    protobuf
    pyparsing
    python-dateutil
    six
    pygments
  ];

  preBuild = ''
    substituteInPlace setup.py --replace '==' '>='
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Channel management tool for lightning network daemon (LND) operators";
    homepage = "https://github.com/bitromortac/lndmanage";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata ];
  };
}
