{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, jsoncpp, libhdhomerun }:
buildKodiBinaryAddon rec {
  pname = "pvr-hdhomerun";
  namespace = "pvr.hdhomerun";
  version = "19.0.1";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.hdhomerun";
    rev = "${version}-${rel}";
    sha256 = "sha256-WeokXU4HY22SzL1djORzru5Hju58Ix0+InwZDr++FC8=";
  };

  extraBuildInputs = [ jsoncpp libhdhomerun ];

  meta = with lib; {
    homepage = "https://github.com/kodi-pvr/pvr.hdhomerun";
    description = "Kodi's HDHomeRun PVR client addon";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
