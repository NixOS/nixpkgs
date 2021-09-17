{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "certifi";
  namespace = "script.module.certifi";
  version = "2020.12.05+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "1z49b8va7wdyr714c8ixb2sldi0igffcjj3xpbmga58ph0z985vy";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.certifi";
    };
  };

  meta = with lib; {
    homepage = "https://certifi.io";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.mpl20;
    maintainers = teams.kodi.members;
  };
}
