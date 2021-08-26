{ lib, buildKodiAddon, fetchzip, addonUpdateScript, certifi, chardet, idna, urllib3 }:
buildKodiAddon rec {
  pname = "requests";
  namespace = "script.module.requests";
  version = "2.25.1+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "00qhykizvspzfwgl7qz9cyxrazs54jgin40g49v5nzmjq3qf62hb";
  };

  propagatedBuildInputs = [
    certifi
    chardet
    idna
    urllib3
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.requests";
    };
  };

  meta = with lib; {
    homepage = "http://python-requests.org";
    description = "Python HTTP for Humans";
    license = licenses.asl20;
    maintainers = teams.kodi.members;
  };
}
