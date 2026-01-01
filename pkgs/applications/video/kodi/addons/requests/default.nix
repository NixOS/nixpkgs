{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  certifi,
  chardet,
  idna,
  urllib3,
}:
buildKodiAddon rec {
  pname = "requests";
  namespace = "script.module.requests";
  version = "2.31.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-05BSD5aoN2CTnjqaSKYMb93j5nIfLvpJHyeQsK++sTw=";
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

<<<<<<< HEAD
  meta = {
    homepage = "http://python-requests.org";
    description = "Python HTTP for Humans";
    license = lib.licenses.asl20;
    teams = [ lib.teams.kodi ];
=======
  meta = with lib; {
    homepage = "http://python-requests.org";
    description = "Python HTTP for Humans";
    license = licenses.asl20;
    teams = [ teams.kodi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
