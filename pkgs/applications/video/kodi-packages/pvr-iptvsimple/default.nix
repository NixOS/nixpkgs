{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, zlib, pugixml }:
buildKodiBinaryAddon rec {
  pname = "pvr-iptvsimple";
  namespace = "pvr.iptvsimple";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.iptvsimple";
    rev = "${version}-${rel}";
    sha256 = "sha256-E+uACZFHoWLTrU2zR5h9aPNzG+3jCB0PNulYmTrE+CI=";
  };

  extraBuildInputs = [ zlib pugixml ];

  meta = with lib; {
    homepage = "https://github.com/kodi-pvr/pvr.iptvsimple";
    description = "Kodi's IPTV Simple client addon";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = teams.kodi.members;
  };
}
