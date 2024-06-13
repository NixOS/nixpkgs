{ lib, buildKodiAddon, fetchzip, kodi-six }:

buildKodiAddon rec {
  pname = "horus";
  namespace = "script.module.horus";
  version = "1.1.9";
  src = fetchzip {
    url = "https://github.com/gtkingbuild/Repo-GTKing/raw/master/omega/zips/${namespace}/${namespace}-${version}.zip";
    hash = "sha256-kbOFChJ0pNT5glz31qyhVofJUwiuXwy9pnevgQer32Q=";
  };

  propagatedBuildInputs = [ kodi-six ];

  meta = with lib; {
    homepage = "https://github.com/gtkingbuild/Repo-GTKing";
    description = "Horus lets you play Acestream links on Kodi";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
