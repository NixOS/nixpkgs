{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub
, xz, pugixml, zlib
, inputstream-adaptive, inputstream-ffmpegdirect, inputstream-rtmp
}:

buildKodiBinaryAddon rec {
  pname = "pvr-iptvsimple";
  namespace = "pvr.iptvsimple";
  version = "7.6.4";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.iptvsimple";
    rev = "${version}-${rel}";
    sha256 = "sha256-F2uvf3BChN4p4VV1vTMAAPwQchVI5paTdxSFEi0u9a0=";
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
