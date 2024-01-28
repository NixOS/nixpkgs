{ lib, python3Packages, fetchFromGitHub, buildPythonPackage }:

buildPythonPackage rec {
  pname = "spotify-cli";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "ledesmablt";
    repo = pname;
    rev = "8e0ad476079a722a39dd2072195c6b4562d18a4d";
    sha256 = "sha256-KSlv+O1XQPFrRyxx8/+lCzWryp+9aXpB5CvhEM9w1wA=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ andreivolt ];
  };
}
