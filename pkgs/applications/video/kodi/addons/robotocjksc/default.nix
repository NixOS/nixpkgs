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

  meta = with lib; {
    homepage = "https://github.com/jurialmunkey/resource.font.robotocjksc";
    description = "Roboto CJKSC fonts";
    license = licenses.asl20;
    teams = [ teams.kodi ];
  };
}
