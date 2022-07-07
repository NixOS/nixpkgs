{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "idna";
  namespace = "script.module.idna";
  version = "3.3.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "gXW1BvM3CLKshVPaemjmzEoZekU0QjuxJY9zGbGwK18=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.idna";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/Freso/script.module.idna";
    description = "Internationalized Domain Names for Python";
    license = licenses.bsd3;
    maintainers = teams.kodi.members;
  };
}
