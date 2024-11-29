{ lib, rel, buildKodiAddon, fetchzip, fetchpatch, addonUpdateScript }:
buildKodiAddon rec {
  pname = "inputstreamhelper";
  namespace = "script.module.inputstreamhelper";
  version = "0.6.1+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-v5fRikswmP+KVbxYibD0NbCK8leUnFbya5EtF1FmS0I=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/emilsvennesson/script.module.inputstreamhelper/commit/af6adc16a0bee4921a827946b004ee070406ae37.patch";
      hash = "sha256-901EyVeZUb0EMvxsEza95qFjTOZ7PDYyqHMRawPM5Zs=";
    })
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.inputstreamhelper";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/emilsvennesson/script.module.inputstreamhelper";
    description = "Simple Kodi module that makes life easier for add-on developers relying on InputStream based add-ons and DRM playback";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
