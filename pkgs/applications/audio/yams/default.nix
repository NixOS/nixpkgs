{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "yams";
  version = "0.69";

  src = fetchFromGitHub {
    owner = "Berulacks";
    repo = "yams";
    rev = "refs/tags/${version}";
    sha256 = "sha256-LjT5BizDFL1gFHCdaDU2eIeyxEIsMzEL0emdjxadTdc=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    psutil
    mpd2
    requests
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Berulacks/yams";
    description = "Last.FM scrobbler for MPD";
    mainProgram = "yams";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ccellado ];
  };
}
