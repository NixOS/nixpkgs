{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "lndmanage";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "bitromortac";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zEz1k98LIOWzqzZ+WNHBHY2hPwWE75bjP+quSdfI/8s=";
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
