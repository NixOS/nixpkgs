{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  addonUpdateScript,
}:
buildKodiAddon rec {
  pname = "infotagger";
  namespace = "script.module.infotagger";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "jurialmunkey";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-Us7ud0QORGn+ALB4uyISekp0kUYY8nN8uFNg8MlxEB0=";
  };

  passthru = {
    # Unusual Python path.
    pythonPath = "resources/modules";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.infotagger";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/jurialmunkey/script.module.infotagger";
    description = "Wrapper for new Nexus InfoTagVideo ListItem methods to maintain backwards compatibility";
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}
