{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, kodi, bzip2, zlib }:

buildKodiBinaryAddon rec {
  pname = "inputstream-ffmpegdirect";
  namespace = "inputstream.ffmpegdirect";
  version = "unstable-20.5.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.ffmpegdirect";
    rev = rel;
    sha256 = "sha256-+u28Wzp2TonL5jaa5WJUr9igR6KiaxizZAX9jqqBUns=";
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
