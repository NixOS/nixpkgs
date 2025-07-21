{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  kodi,
  bzip2,
  zlib,
}:

buildKodiBinaryAddon rec {
  pname = "inputstream-ffmpegdirect";
  namespace = "inputstream.ffmpegdirect";
  version = "21.3.8";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.ffmpegdirect";
    rev = "${version}-${rel}";
    sha256 = "sha256-IgCSEJzu3a2un7FdiZCEVs/boxvIhSNleTPpOCljCZo=";
  };

  extraBuildInputs = [
    bzip2
    zlib
    kodi.ffmpeg
  ];

  meta = with lib; {
    homepage = "https://github.com/xbmc/inputstream.ffmpegdirect/";
    description = "InputStream Client for streams that can be opened by either FFmpeg's libavformat or Kodi's cURL";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    teams = [ teams.kodi ];
  };
}
