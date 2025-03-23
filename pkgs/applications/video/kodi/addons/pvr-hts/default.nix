{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
}:
buildKodiBinaryAddon rec {
  pname = "pvr-hts";
  namespace = "pvr.hts";
  version = "21.2.5";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.hts";
    rev = "${version}-${rel}";
    sha256 = "sha256-BG5mGD674gvjUSdydu4g3F/4GH53gkJoKMDuvaFNi6k=";
  };

  meta = with lib; {
    homepage = "https://github.com/kodi-pvr/pvr.hts";
    description = "Kodi's Tvheadend HTSP client addon";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
