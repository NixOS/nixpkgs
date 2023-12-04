{ lib, buildKodiAddon, fetchFromGitHub, signals, inputstream-adaptive, inputstreamhelper, requests, myconnpy }:

buildKodiAddon rec {
  pname = "netflix";
  namespace = "plugin.video.netflix";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "CastagnaIT";
    repo = namespace;
    rev = "v${version}";
    sha256 = "sha256-hMGL1DojtSFOV6dX7MC+68aXnN+DEDieQN7GJBbGiZM=";
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
    maintainers = teams.kodi.members ++ [ maintainers.pks ];
  };
}
