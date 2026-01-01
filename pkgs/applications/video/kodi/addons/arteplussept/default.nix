{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  dateutil,
  requests,
  xbmcswift2,
}:

buildKodiAddon rec {
  pname = "arteplussept";
  namespace = "plugin.video.arteplussept";
<<<<<<< HEAD
  version = "1.4.4";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    hash = "sha256-jFIcLhglfOqkFLtlIJKB1o++mWfnpWKS3w1wD0S3+CE=";
=======
  version = "1.4.3";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    hash = "sha256-05k0ijTp0JDtHdxTJ5I8ff47F6LXGP78rInyX0nD7W8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    dateutil
    requests
    xbmcswift2
  ];

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.arteplussept";
    };
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/thomas-ernest/plugin.video.arteplussept";
    description = "Watch videos available on Arte+7";
    license = lib.licenses.mit;
    teams = [ lib.teams.kodi ];
=======
  meta = with lib; {
    homepage = "https://github.com/thomas-ernest/plugin.video.arteplussept";
    description = "Watch videos available on Arte+7";
    license = licenses.mit;
    teams = [ teams.kodi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
