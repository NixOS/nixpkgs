{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub }:
buildKodiBinaryAddon rec {
  pname = "pvr-hts";
  namespace = "pvr.hts";
  version = "8.3.1";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.hts";
    rev = "${version}-${rel}";
    sha256 = "sha256-bk9z2K/Y7V6wTSxaujh4l6+5gqM+nXHEKpvw6hVVHMQ=";
  };

  meta = with lib; {
    homepage = "https://github.com/kodi-pvr/pvr.hts";
    description = "Kodi's Tvheadend HTSP client addon";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
