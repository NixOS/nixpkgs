{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "signals";
  namespace = "script.module.addon.signals";
  version = "0.0.6+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "1qcjbakch8hvx02wc01zv014nmzgn6ahc4n2bj5mzr114ppd3hjs";
  };

  passthru= {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.signals";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/ruuk/script.module.addon.signals";
    description = "Provides signal/slot mechanism for inter-addon communication";
    license = licenses.lgpl21Only;
    maintainers = teams.kodi.members;
  };
}
