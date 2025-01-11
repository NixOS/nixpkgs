{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  signals,
  inputstream-adaptive,
  inputstreamhelper,
  requests,
  myconnpy,
}:

buildKodiAddon rec {
  pname = "netflix";
  namespace = "plugin.video.netflix";
  version = "1.23.3";

  src = fetchFromGitHub {
    owner = "CastagnaIT";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-tve7E7dK60BIHETdwt9hD3/5eEdJB6c6rhw4oDoLAKM=";
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
