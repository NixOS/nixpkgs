{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "htmlement";
  namespace = "script.module.htmlement";
  version = "1.0.0+matrix.1";

  src = fetchzip {
    url =
      "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-As9DsZBHepM4+HkMuEI+aTg6LVsAyKp2H2diQuRv/48=";
  };

  passthru = {
    pythonPath = "lib";
  };

  meta = with lib; {
    homepage = "https://pypi.org/project/htmlement/";
    description = "Pure-Python HTML parser with ElementTree XPath support.";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
