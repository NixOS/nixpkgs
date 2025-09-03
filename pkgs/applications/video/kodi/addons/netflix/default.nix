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
  version = "1.23.5";

  src = fetchFromGitHub {
    owner = "CastagnaIT";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-IIRut99AH08Z3udTkzUf2wz7dQMA94dOnfROm7iM9RM=";
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
    maintainers = [ maintainers.pks ];
    teams = [ teams.kodi ];
  };
}
