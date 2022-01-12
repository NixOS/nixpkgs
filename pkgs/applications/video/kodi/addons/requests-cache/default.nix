{ lib, buildKodiAddon, fetchzip, addonUpdateScript, requests }:
buildKodiAddon rec {
  pname = "requests-cache";
  namespace = "script.module.requests-cache";
  version = "0.5.2+matrix.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "0fgl4jayq6hbhqxg16nfy9qizwf54c8nvg0icv93knaj13zfzkz8";
  };

  propagatedBuildInputs = [
    requests
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.requests-cache";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/reclosedev/requests-cache";
    description = "Persistent cache for requests library";
    license = licenses.bsd2;
    maintainers = teams.kodi.members;
  };
}
