{ lib, buildKodiAddon, fetchFromGitHub, addonUpdateScript }:
buildKodiAddon rec {
  pname = "infotagger";
  namespace = "script.module.infotagger";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "jurialmunkey";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-Ns1OjrYLKz4znXRxqUErDLcmC0HBjBFVYI9GFqDVurY=";
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
