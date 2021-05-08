{ lib, buildKodiAddon, fetchFromGitHub, signals, inputstream-adaptive, inputstreamhelper, requests, myconnpy }:

buildKodiAddon rec {
  pname = "netflix";
  namespace = "plugin.video.netflix";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "CastagnaIT";
    repo = namespace;
    rev = "v${version}";
    sha256 = "0c5cdi6s76vg2gyxzf0ylisxai1ii8vi6h4q4mznpfmplfdp667v";
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
