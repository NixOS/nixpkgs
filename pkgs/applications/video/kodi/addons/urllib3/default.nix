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
  version = "2.1.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-UCvkeguxytPoP1gIIt8N79TVs98ATzsfrRSabtbgnGc=";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.urllib3";
    };
  };

  meta = {
    homepage = "https://urllib3.readthedocs.io/en/latest/";
    description = "HTTP library with thread-safe connection pooling, file post, and more";
    license = lib.licenses.mit;
    maintainers = lib.teams.kodi.members;
  };
}
