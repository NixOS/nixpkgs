{ lib, buildKodiAddon, fetchpatch, fetchzip, addonUpdateScript, requests, inputstream-adaptive, inputstreamhelper }:

buildKodiAddon rec {
  pname = "invidious";
  namespace = "plugin.video.invidious";
  version = "0.1.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-4z2/YTso5KV6JHS/DOXll2lKOoVnW1i5MnpmV6ESXbM=";
  };

  propagatedBuildInputs = [
    requests
    inputstream-adaptive
    inputstreamhelper
  ];

  passthru = {
    pythonPath = "resources/lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.invidious";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/TheAssassin/kodi-invidious-plugin";
    description = "A privacy-friendly way of watching YouTube content";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
