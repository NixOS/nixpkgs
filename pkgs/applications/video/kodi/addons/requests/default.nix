{ lib, buildKodiAddon, fetchzip, addonUpdateScript, certifi, chardet, idna, urllib3 }:
buildKodiAddon rec {
  pname = "requests";
  namespace = "script.module.requests";
  version = "2.27.1+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-QxxVT6XaEYQtAFkZde8EaTXzGO7cjG2pApQZcA32xA0=";
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
