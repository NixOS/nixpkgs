{ lib, rel, buildKodiAddon, fetchzip, addonUpdateScript, dateutil, typing_extensions }:
buildKodiAddon rec {
  pname = "arrow";
  namespace = "script.module.arrow";
  version = "1.2.3";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/script.module.arrow/script.module.arrow-${version}.zip";
    sha256 = "sha256-Et+9FJT1dRE1dFOrAQ70HJJcfylyLsiyay9wPJcSOXs=";
  };

  propagatedBuildInputs = [
    dateutil
    typing_extensions
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.arrow";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/razzeee/script.module.arrow";
    description = "Better dates & times for Python";
    license = licenses.asl20;
    maintainers = teams.kodi.members;
  };
}
