{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, kodi, bzip2, zlib }:

buildKodiBinaryAddon rec {
  pname = "inputstream-ffmpegdirect";
  namespace = "inputstream.ffmpegdirect";
  version = "1.19.4";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.ffmpegdirect";
    rev = "${version}-${rel}";
    sha256 = "1ppvs6zybbi73zq1qh8klyhj99byh61c6nijmb1gd5yhg7cywf72";
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
