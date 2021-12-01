{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "idna";
  namespace = "script.module.idna";
  version = "2.10.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "0pm86m8kh2p0brps3xzxcmmabvb4izkglzkj8dsn33br3vlc7cm7";
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
