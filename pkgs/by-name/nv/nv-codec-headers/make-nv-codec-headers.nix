{
  pname,
  version,
  hash,
}:

{
  lib,
  fetchgit,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "n${version}";
    inherit hash;
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    homepage = "https://ffmpeg.org/";
    description = "FFmpeg version of headers for NVENC - version ${version}";
    downloadPage = "https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
}
