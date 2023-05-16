{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "lndmanage";
<<<<<<< HEAD
  version = "0.15.0";
=======
  version = "0.14.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bitromortac";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-zEz1k98LIOWzqzZ+WNHBHY2hPwWE75bjP+quSdfI/8s=";
=======
    hash = "sha256-G6KpF/c8FsXrqI0hB0fZlModQThnAOHrCv482UjRng0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
