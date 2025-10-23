{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  requests,
}:

buildKodiAddon rec {
  pname = "formula1";
  namespace = "plugin.video.formula1";
  version = "2.0.7";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-yz9SB0hiw5JKURGNvAazxazL+bMtfziNXlOLLoGUPOU=";
  };

  propagatedBuildInputs = [
    requests
  ];

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.formula1";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/jaylinski/kodi-addon-formula1";
    description = "Videos from the Formula 1 website";
    license = licenses.mit;
    teams = [ teams.kodi ];
  };
}
