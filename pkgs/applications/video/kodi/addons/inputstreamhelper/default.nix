{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "inputstreamhelper";
  namespace = "script.module.inputstreamhelper";
  version = "0.5.10+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "FcOktwtOT7kDM+3y9qPDk3xU1qVeCduyAdUzebtJzv4=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.inputstreamhelper";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/emilsvennesson/script.module.inputstreamhelper";
    description = "A simple Kodi module that makes life easier for add-on developers relying on InputStream based add-ons and DRM playback";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
