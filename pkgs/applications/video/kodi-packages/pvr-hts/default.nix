{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub }:
buildKodiBinaryAddon rec {
  pname = "pvr-hts";
  namespace = "pvr.hts";
  version = "19.0.3";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.hts";
    rev = "${version}-${rel}";
    sha256 = "sha256-kO+wRFt4MudYP9UOTaruRCWs/QMla+BYTRfSUdlVpR8=";
  };

  meta = with lib; {
    homepage = "https://github.com/kodi-pvr/pvr.hts";
    description = "Kodi's Tvheadend HTSP client addon";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
