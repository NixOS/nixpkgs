{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  six,
}:

buildKodiAddon rec {
  pname = "dateutil";
  namespace = "script.module.dateutil";
  version = "2.8.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-iQnyS0GjYcPbnBDUxmMrmDxHOA3K8RbTVke/HF4d5u4=";
  };

  propagatedBuildInputs = [
    six
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.dateutil";
    };
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://dateutil.readthedocs.io/en/stable/";
    description = "Extensions to the standard Python datetime module";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    teams = [ lib.teams.kodi ];
=======
  meta = with lib; {
    homepage = "https://dateutil.readthedocs.io/en/stable/";
    description = "Extensions to the standard Python datetime module";
    license = with licenses; [
      asl20
      bsd3
    ];
    teams = [ teams.kodi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
