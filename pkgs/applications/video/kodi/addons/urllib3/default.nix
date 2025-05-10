{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:

buildKodiAddon rec {
  pname = "urllib3";
  namespace = "script.module.urllib3";
  version = "2.2.3";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-xapFA51ENjkB3IldUey5WqXAjMij66dNqILQjKD/VkA=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.urllib3";
    };
  };

  meta = with lib; {
    homepage = "https://urllib3.readthedocs.io/en/latest/";
    description = "HTTP library with thread-safe connection pooling, file post, and more";
    license = licenses.mit;
    teams = [ teams.kodi ];
  };
}
