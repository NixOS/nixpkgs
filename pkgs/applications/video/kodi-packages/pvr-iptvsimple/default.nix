{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub
, xz, pugixml, zlib
, inputstream-adaptive, inputstream-ffmpegdirect, inputstream-rtmp
}:

buildKodiBinaryAddon rec {
  pname = "pvr-iptvsimple";
  namespace = "pvr.iptvsimple";
  version = "7.6.5";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.iptvsimple";
    rev = "${version}-${rel}";
    sha256 = "sha256-Z4H+5dUYJ3vAgodPxWmttVhPVdPVYTJbmYxo1lzLHNA=";
  };

  extraBuildInputs = [
    xz
    pugixml
    zlib
  ];
  propagatedBuildInputs = [
    inputstream-adaptive
    inputstream-ffmpegdirect
    inputstream-rtmp
  ];

  meta = with lib; {
    homepage = "https://github.com/kodi-pvr/pvr.iptvsimple";
    description = "Kodi's IPTV Simple client addon";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = teams.kodi.members;
  };
}
