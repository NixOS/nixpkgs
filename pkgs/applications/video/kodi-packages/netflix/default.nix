{ lib, buildKodiAddon, fetchFromGitHub, signals, inputstream-adaptive, inputstreamhelper, requests, myconnpy }:

buildKodiAddon rec {
  pname = "netflix";
  namespace = "plugin.video.netflix";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "CastagnaIT";
    repo = namespace;
    rev = "v${version}";
    sha256 = "0yycwm8vrpkr4fsbf713mhpnaxfd849nhzp5r1898sb9vldab4xk";
  };

  propagatedBuildInputs = [
    signals
    inputstream-adaptive
    inputstreamhelper
    requests
    myconnpy
  ];

  meta = with lib; {
    homepage = "https://github.com/CastagnaIT/plugin.video.netflix";
    description = "Netflix VOD Services Add-on";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
