{ ffmpeg_7 }:
{
  # needs avcodec_close which was removed in ffmpeg 8
  ffmpeg = ffmpeg_7;
}
