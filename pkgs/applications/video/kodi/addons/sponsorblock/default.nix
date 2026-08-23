{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  six,
  requests,
}:
buildKodiAddon rec {
  pname = "sponsorblock";
  namespace = "script.service.sponsorblock";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "siku2";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-9+0gIY12C+bZNsCRzla1IFmtVZiiGnS4TL3srkOBWsQ=";
  };

  propagatedBuildInputs = [
    six
    requests
  ];

  passthru = {
    pythonPath = "resources/lib";
  };

  meta = {
    homepage = "https://github.com/siku2/script.service.sponsorblock";
    description = "Port of SponsorBlock for Invidious and YouTube Plugin";
    license = lib.licenses.mit;
    teams = [ lib.teams.kodi ];
  };
}
