{ lib, rel, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "defusedxml";
  namespace = "script.module.defusedxml";
  version = "0.6.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-jSl7lbFqR6hjZhHzxY69hDbs84LY3B5RYKzXnHou0Qg=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.defusedxml";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/tiran/defusedxml";
    description = "defusing XML bombs and other exploits";
    license = licenses.psfl;
    maintainers = teams.kodi.members;
  };
}
