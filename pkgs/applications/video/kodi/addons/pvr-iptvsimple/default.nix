{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  xz,
  pugixml,
  zlib,
  inputstream-adaptive,
  inputstream-ffmpegdirect,
  inputstream-rtmp,
}:

buildKodiBinaryAddon rec {
  pname = "pvr-iptvsimple";
  namespace = "pvr.iptvsimple";
  version = "21.10.2";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.iptvsimple";
    rev = "${version}-${rel}";
    sha256 = "sha256-bw0rAEn8R44n5Nzc9ni6IGaG/Bxry6GSyWcT6BdgLz8=";
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
    teams = [ teams.kodi ];
  };
}
