{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "pyqrcode";
  namespace = "script.module.pyqrcode";
  version = "1.2.1+matrix.4";

  src = fetchzip {
    url =
      "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-amqEdEu3gXlshWBzCXBE7myjaVB9fLBwA91YHadoIFg=";
  };

  passthru = {
    pythonPath = "lib";
  };

  meta = with lib; {
    homepage = "https://pypi.org/project/PyQRCode/";
    description = "Python 3 module to generate QR Codes";
    license = licenses.bsd3;
    maintainers = teams.kodi.members;
  };
}
