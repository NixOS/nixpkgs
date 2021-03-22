{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
  pname = "chardet";
  namespace = "script.module.chardet";
  version = "3.0.4+matrix.3";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "05928dj4fsj2zg8ajdial3sdf8izddq64sr0al3zy1gqw91jp80f";
  };

  passthru.updateScript = addonUpdateScript {
    attrPath = "kodi.packages.chardet";
  };

  meta = with lib; {
    homepage = "https://github.com/Freso/script.module.chardet";
    description = "Universal encoding detector";
    license = licenses.lgpl2Only;
    maintainers = teams.kodi.members;
  };
}
