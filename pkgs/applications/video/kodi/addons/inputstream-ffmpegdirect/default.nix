{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, kodi, bzip2, zlib }:

buildKodiBinaryAddon rec {
  pname = "inputstream-ffmpegdirect";
  namespace = "inputstream.ffmpegdirect";
  version = "19.0.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.ffmpegdirect";
    rev = "${version}-${rel}";
    sha256 = "sha256-qdN2tmwS6uD9wrHnKC3iNvHnA2WlJAoNhdwvw16/L0U=";
  };

  extraBuildInputs = [ bzip2 zlib kodi.ffmpeg ];

  meta = with lib; {
    homepage = "https://github.com/xbmc/inputstream.ffmpegdirect/";
    description = "InputStream Client for streams that can be opened by either FFmpeg's libavformat or Kodi's cURL";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = teams.kodi.members;
  };
}
