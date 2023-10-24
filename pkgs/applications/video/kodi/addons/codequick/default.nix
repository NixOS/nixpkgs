{ lib, buildKodiAddon, fetchFromGitHub, addonUpdateScript, youtube-dl, requests
, htmlement }:

buildKodiAddon rec {
  pname = "codequick";
  namespace = "script.module.codequick";
  version = "v1.0.3";

  src = fetchFromGitHub {
    owner = "willforde";
    repo = "script.module.codequick";
    rev = "eda621dcde7170432849aab7f54279288d9a08c9";
    hash = "sha256-Rr9VYWrwn1RrCcQ0UdgOnQOoIrdB52JJ0pR4VI7dSAg=";
  };

  propagatedBuildInputs = [ youtube-dl requests htmlement ];

  passthru = { pythonPath = "lib"; };

  meta = with lib; {
    homepage = "https://github.com/willforde/script.module.codequick/";
    description = "Kodi addon framework";
    license = licenses.gpl2;
    maintainers = teams.kodi.members;
  };
}
