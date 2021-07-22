{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "inputstreamhelper";
  namespace = "script.module.inputstreamhelper";
  version = "0.5.5+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "0y4xn3ygwv1kb7gya7iwdga0g9sa89snpnram0wwqzqn8wn2lyb4";
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
