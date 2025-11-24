{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  requests,
  infotagger,
}:

buildKodiAddon rec {
  pname = "jurialmunkey";
  namespace = "script.module.jurialmunkey";
  version = "0.2.29";

  src = fetchFromGitHub {
    owner = "jurialmunkey";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-qVS3vwYFicDXZ8ls/5MfZL8iwmz+CAwB6ZWUV4Zjmbw=";
  };

  propagatedBuildInputs = [
    requests
    infotagger
  ];

  passthru = {
    pythonPath = "resources/modules";
  };

  meta = with lib; {
    homepage = "https://github.com/jurialmunkey/script.module.jurialmunkey/tree/main";
    description = "Common code required by TMDbHelper and other related jurialmunkey add-ons";
    license = licenses.gpl3Plus;
    teams = [ teams.kodi ];
  };
}
