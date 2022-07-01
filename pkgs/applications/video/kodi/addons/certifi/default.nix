{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "certifi";
  namespace = "script.module.certifi";
  version = "2022.5.18+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "tk4Ven35sicLxrT7SO2yx5kQORjFP6niRuS9SMocJKY=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.certifi";
    };
  };

  meta = with lib; {
    homepage = "https://certifi.io";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.mpl20;
    maintainers = teams.kodi.members;
  };
}
