{ lib, buildKodiAddon, fetchzip, addonUpdateScript, six }:

buildKodiAddon rec {
  pname = "dateutil";
  namespace = "script.module.dateutil";
  version = "2.8.1+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "1jr77017ihs7j3455i72af71wyvs792kbizq4539ccd98far8lm7";
  };

  propagatedBuildInputs = [
    six
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.dateutil";
    };
  };

  meta = with lib; {
    homepage = "https://dateutil.readthedocs.io/en/stable/";
    description = "Extensions to the standard Python datetime module";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = teams.kodi.members;
  };
}
