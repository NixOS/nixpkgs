{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, kodi, bzip2, zlib }:

buildKodiBinaryAddon rec {
  pname = "inputstream-ffmpegdirect";
  namespace = "inputstream.ffmpegdirect";
  version = "21.3.5";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.ffmpegdirect";
    rev = "${version}-${rel}";
    sha256 = "sha256-pPufkDPHq5EsvC6YTsRX9TjqjIczOL/6Vc5HGDIe9Gk=";
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
