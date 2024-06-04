{ lib, rel, buildKodiAddon, fetchzip, addonUpdateScript, defusedxml, kodi-six }:

buildKodiAddon rec {
  pname = "keymap";
  namespace = "script.keymap";
  version = "1.2.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-AtIufZbOi3MW7aSOAlON8csJheJqAbuBtKIX0sX6zIw=";
  };

  propagatedBuildInputs = [
    defusedxml
    kodi-six
  ];

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.keymap";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/tamland/xbmc-keymap-editor";
    description = "A GUI for configuring mappings for remotes, keyboard and other inputs supported by Kodi";
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}
