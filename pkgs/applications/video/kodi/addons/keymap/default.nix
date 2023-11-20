{ lib, buildKodiAddon, fetchzip, addonUpdateScript, defusedxml, kodi-six }:

buildKodiAddon rec {
  pname = "keymap";
  namespace = "script.keymap";
  version = "1.1.5";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-wSztipTEGIqw1icsz+ziNxYuRZOFt3C66T1Ifap/ta0=";
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
