{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, zlib, pugixml }:
buildKodiBinaryAddon rec {
  pname = "pvr-iptvsimple";
  namespace = "pvr.iptvsimple";
  version = "7.4.2";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.iptvsimple";
    rev = "${version}-${rel}";
    sha256 = "062i922qi0izkvn7v47yhyy2cf3fa7xc3k95b1gm9abfdwkk8ywr";
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
