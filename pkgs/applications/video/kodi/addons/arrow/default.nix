{ lib, buildKodiAddon, fetchzip, addonUpdateScript, dateutil, typing_extensions }:
buildKodiAddon rec {
  pname = "arrow";
  namespace = "script.module.arrow";
  version = "1.0.3.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/script.module.arrow/script.module.arrow-${version}.zip";
    sha256 = "sha256-dFCAHlWgslxsAVQAPP3aDM6Fw+I9PP0ITUVTKJY2QXU=";
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
