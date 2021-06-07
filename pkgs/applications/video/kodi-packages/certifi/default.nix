{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "certifi";
  namespace = "script.module.certifi";
  version = "2019.11.28+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "0vsd68izv1ix0hb1gm74qq3zff0sxmhfhjyh7y9005zzp2gpi62v";
  };

  passthru.updateScript = addonUpdateScript {
    attrPath = "kodi.packages.certifi";
  };

  meta = with lib; {
    homepage = "https://certifi.io";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.mpl20;
    maintainers = teams.kodi.members;
  };
}
