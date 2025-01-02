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
  version = "2.0.3";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-T2q7/bbzarjbqmLQR5g5lBnO0mdrwrWX5/c5GZ48nKM=";
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
    maintainers = teams.kodi.members;
  };
}
