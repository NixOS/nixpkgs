{ lib, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  pname = "mps-youtube";
  version = "unstable-2020-01-28";

  src = fetchFromGitHub {
    owner = "mps-youtube";
    repo = "mps-youtube";
    rev = "b808697133ec2ad7654953232d1e841b20aa7cc3";
    sha256 = "0lqprlpc0v092xqkjc0cc395ag45lijwgd34dpg2jy6i0f2szywv";
  };

  propagatedBuildInputs = [ pafy ];

  # disabled due to error in loading unittest
  # don't know how to make test from: <mps_youtube. ...>
  doCheck = false;

  # before check create a directory and redirect XDG_CONFIG_HOME to it
  preCheck = ''
    mkdir -p check-phase
    export XDG_CONFIG_HOME=$(pwd)/check-phase
  '';

  meta = with lib; {
    description = "Terminal based YouTube player and downloader";
    homepage = "https://github.com/mps-youtube/mps-youtube";
    license = licenses.gpl3;
    maintainers = with maintainers; [ koral odi ];
  };
}
