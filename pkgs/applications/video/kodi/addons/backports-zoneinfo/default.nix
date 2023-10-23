{ lib, buildKodiAddon, fetchzip, addonUpdateScript, tzdata }:

buildKodiAddon rec {
  pname = "backports-zoneinfo";
  namespace = "script.module.backports.zoneinfo";
  version = "0.2.1";

  src = fetchzip {
    url =
      "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-vvW8HUeRJ+gJorkrqQRx3SLl98MB0fVtDJe4D+FpnAs=";
  };

  propagatedBuildInputs = [ tzdata ];

  passthru = {
    pythonPath = "lib";
  };

  meta = with lib; {
    homepage = "https://pypi.org/project/backports.zoneinfo/";
    description =
      "Reference implementation for the proposed standard library module zoneinfo";
    license = licenses.asl20;
    maintainers = teams.kodi.members;
  };
}
