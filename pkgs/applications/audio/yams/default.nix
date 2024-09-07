{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "yams";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Berulacks";
    repo = "yams";
    rev = version;
    sha256 = "1zkhcys9i0s6jkaz24an690rvnkv1r84jxpaa84sf46abi59ijh8";
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
