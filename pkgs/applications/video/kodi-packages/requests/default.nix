{ lib, buildKodiAddon, fetchzip, addonUpdateScript, certifi, chardet, idna, urllib3 }:
buildKodiAddon rec {
  pname = "requests";
  namespace = "script.module.requests";
  version = "2.22.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "09576galkyzhw8fhy2h4aablm5rm2v08g0mdmg9nn55dlxhkkljq";
  };

  propagatedBuildInputs = [
    certifi
    chardet
    idna
    urllib3
  ];

  passthru.updateScript = addonUpdateScript {
    attrPath = "kodi.packages.requests";
  };

  meta = with lib; {
    homepage = "http://python-requests.org";
    description = "Python HTTP for Humans";
    license = licenses.asl20;
    maintainers = teams.kodi.members;
  };
}
