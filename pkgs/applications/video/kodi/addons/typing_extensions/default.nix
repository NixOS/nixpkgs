{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:
buildKodiAddon rec {
  pname = "typing_extensions";
  namespace = "script.module.typing_extensions";
  version = "4.7.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-bCGPl5fGVyptCenpNXP/Msi7hu+UdtZd2ms7MfzbsbM=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.typing_extensions";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/python/typing/tree/master/typing_extensions";
    description = "Python typing extensions";
    license = licenses.psfl;
    maintainers = teams.kodi.members;
  };
}
