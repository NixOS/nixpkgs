{ lib, addonDir, buildKodiAddon, fetchzip, defusedxml, kodi-six }:

buildKodiAddon rec {
  pname = "keymap";
  namespace = "script.keymap";
  version = "1.1.3+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "1icrailzpf60nw62xd0khqdp66dnr473m2aa9wzpmkk3qj1ay6jv";
  };

  propagatedBuildInputs = [
    defusedxml
    kodi-six
  ];

  meta = with lib; {
    homepage = "https://github.com/tamland/xbmc-keymap-editor";
    description = "A GUI for configuring mappings for remotes, keyboard and other inputs supported by Kodi";
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}
