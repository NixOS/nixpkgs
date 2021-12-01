{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, jsoncpp, libhdhomerun }:
buildKodiBinaryAddon rec {
  pname = "pvr-hdhomerun";
  namespace = "pvr.hdhomerun";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.hdhomerun";
    rev = "${version}-${rel}";
    sha256 = "sha256-mQeeeCOxhUTiUcOJ1OiIiJ+7envAIGO67Bp4EAf4sIE=";
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
