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
  version = "1.23.4";

  src = fetchFromGitHub {
    owner = "CastagnaIT";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-yq5XNhKQSBh7r/2apHXLMjhovV6xhL9DcDwXn9nt0KQ=";
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
