{ lib, buildKodiAddon, fetchFromGitHub, signals, inputstream-adaptive, inputstreamhelper, requests, myconnpy }:

buildKodiAddon rec {
  pname = "netflix";
  namespace = "plugin.video.netflix";
  version = "1.22.3";

  src = fetchFromGitHub {
    owner = "CastagnaIT";
    repo = namespace;
    rev = "v${version}";
    sha256 = "sha256-8NGj8n1p8euqYYdPDSeFh2ZE9lly5ThSmg69yXY3Te8=";
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
