{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
}:

buildKodiAddon rec {
  pname = "robotocjksc";
  namespace = "resource.font.robotocjksc";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "jurialmunkey";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-s/h/KKlGYGMvf7RdI9ONk4S+NCzlaDX5w3CdNfbC2KE=";
  };

  meta = {
    homepage = "https://github.com/jurialmunkey/resource.font.robotocjksc";
    description = "Roboto CJKSC fonts";
    license = lib.licenses.asl20;
    teams = [ lib.teams.kodi ];
  };
}
