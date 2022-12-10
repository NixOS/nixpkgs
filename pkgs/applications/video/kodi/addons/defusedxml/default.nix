{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "defusedxml";
  namespace = "script.module.defusedxml";
  version = "0.6.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "026i5rx9rmxcc18ixp6qhbryqdl4pn7cbwqicrishivan6apnacd";
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
