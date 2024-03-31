{ lib, buildKodiAddon, fetchFromGitHub, six, requests }:
buildKodiAddon rec {
  pname = "sponsorblock";
  namespace = "script.service.sponsorblock";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "siku2";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-IBgh2kdPgCy+HHrR7UZxTgjF1LR77ABGlUp3PgaobNM=";
  };

  propagatedBuildInputs = [
    six
    requests
  ];

  passthru = {
    pythonPath = "resources/lib";
  };

  meta = with lib; {
    homepage = "https://github.com/siku2/script.service.sponsorblock";
    description = "A Port of SponsorBlock for Invidious and YouTube Plugin";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
