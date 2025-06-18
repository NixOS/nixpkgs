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
  version = "0.2.28";

  src = fetchFromGitHub {
    owner = "jurialmunkey";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-3bT1mFzY28r3tzb5zrLKwLs83uotfKezI020SetJuso=";
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
