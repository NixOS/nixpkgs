{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "routing";
  namespace = "script.module.routing";
  version = "0.2.3+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "1qhp40xd8mbcvzwlamqw1j5l224ry086593948g24drpqiiyc8x6";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.routing";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/tamland/kodi-plugin-routing";
    description = "A routing module for kodi plugins";
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}
