{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, jsoncpp, libhdhomerun }:
buildKodiBinaryAddon rec {
  pname = "pvr-hdhomerun";
  namespace = "pvr.hdhomerun";
  version = "21.0.1";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.hdhomerun";
    rev = "${version}-${rel}";
    sha256 = "sha256-Hb8TcJxRUIKHbevAUgt5q6z26W3uX9NbVwYyvrLnf7U=";
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
