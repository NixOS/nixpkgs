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
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "jurialmunkey";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-vcYydVrcVJ7jaeFXCad7pgxvoZy63QLlRS3HO9GsmtU=";
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
    maintainers = teams.kodi.members;
  };
}
