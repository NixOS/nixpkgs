{ lib, buildKodiAddon, fetchzip, addonUpdateScript, dateutil, typing_extensions }:
buildKodiAddon rec {
  pname = "arrow";
  namespace = "script.module.arrow";
  version = "1.0.3.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "0xa16sb2hls59l4gsg1xwb1qbkhcvbykq02l05n5rcm0alg80l3l";
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
