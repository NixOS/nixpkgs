{ lib, python3Packages, fetchFromGitHub, buildPythonApplication }:

buildPythonApplication rec {
  pname = "spotify-cli";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "ledesmablt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-25eMM63a/axgDXCXah+zxwgXyrFHEciGE97ya49r43c=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    inquirerpy
    tabulate
  ];

  preBuild = ''
    export RELEASE_VERSION=${version}
  '';

  doCheck = false;

  meta = with lib; {
    description = "Control Spotify playback on any device through the command line.";
    homepage = "https://github.com/ledesmablt/spotify-cli";
    mainProgram = "spotify-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ andreivolt ];
  };
}
