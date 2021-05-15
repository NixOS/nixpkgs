{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "idna";
  namespace = "script.module.idna";
  version = "2.8.1+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "02s75fhfmbs3a38wvxba51aj3lv5bidshjdkl6yjfji6waxpr9xh";
  };

  passthru.updateScript = addonUpdateScript {
    attrPath = "kodi.packages.idna";
  };

  meta = with lib; {
    homepage = "https://github.com/Freso/script.module.idna";
    description = "Internationalized Domain Names for Python";
    license = licenses.bsd3;
    maintainers = teams.kodi.members;
  };
}
