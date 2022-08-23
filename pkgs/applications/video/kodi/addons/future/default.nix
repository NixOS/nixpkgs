{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "future";
  namespace = "script.module.future";
  version = "0.18.2+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-QBG7V70Dwmfq8ISILxGNvtmQT9fJp2e5gs2C9skRwIw=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.future";
    };
  };

  meta = with lib; {
    homepage = "https://python-future.org";
    description = "The missing compatibility layer between Python 2 and Python 3";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
