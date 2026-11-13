{
  lib,
  stdenv,
  ffmpeg_6,
  pkg-config,
  nasm,
  zlib,
  openssl,
  libvpx,
  libaom,
  libopus,
  openh264,
  libwebp,
  srt,
  x264,
}:

# OvenMediaEngine requires a minimal FFmpeg build with the following
# configuration, as specified in its upstream InstallPrerequisites.cmake
# file.
# Source: https://github.com/OvenMediaLabs/OvenMediaEngine/blob/f51b318076bba2e9557b9cd74b5c7008ec5f9474/cmake/InstallPrerequisites.cmake
# Modifications
# - Disable libfdk_aac (requires --enable-nonfree) to keep this build fully free.
# - Uses ffmpeg_6 instead of ffmpeg_5
stdenv.mkDerivation {
  pname = "ffmpeg-ome-minimal";
  version = ffmpeg_6.version;

  src = ffmpeg_6.src;

  nativeBuildInputs = [
    pkg-config
    nasm
  ];

  buildInputs = [
    zlib
    openssl
    libvpx
    libaom
    libopus
    openh264
    libwebp
    srt
    x264
  ];

  configureFlags = [
    "--disable-everything"
    "--disable-programs"
    "--disable-avdevice"
    "--disable-dwt"
    "--disable-lsp"
    "--disable-faan"
    "--disable-pixelutils"
    "--enable-shared"
    "--disable-static"
    "--enable-pic"
    "--enable-zlib"
    "--enable-libopus"
    "--enable-libvpx"
    "--enable-libaom"
    "--enable-libopenh264"
    "--enable-openssl"
    "--enable-network"
    "--enable-libsrt"
    "--enable-libwebp"
    "--extra-libs=-ldl"
    "--enable-gpl"
    "--enable-version3"
    "--enable-libx264"
    "--disable-nvdec"
    "--disable-vaapi"
    "--disable-vdpau"
    "--disable-cuda-llvm"
    "--disable-cuvid"
    "--disable-ffnvcodec"
    "--enable-encoder=libvpx_vp8,libaom-av1,libopus,aac,libopenh264,mjpeg,png,libwebp,libx264"
    "--enable-decoder=aac,aac_latm,aac_fixed,mp2,mp2float,mp3float,mp3,h264,hevc,libaom-av1,opus,vp8,mjpeg,png"
    "--enable-parser=aac,aac_latm,aac_fixed,h264,hevc,mpegaudio,opus,vp8,png,jpg"
    "--enable-protocol=tcp,udp,rtp,file,rtmp,tls,rtmps,libsrt"
    "--enable-demuxer=rtsp,flv,live_flv,mp4,mp3,image2"
    "--enable-muxer=mp4,webm,mpegts,flv,mpjpeg"
    "--enable-filter=asetnsamples,aresample,aformat,channelmap,channelsplit,scale,transpose,fps,settb,asettb,crop,format"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Minimal FFmpeg build for OvenMediaEngine, replicating its upstream InstallPrerequisites.cmake configuration";
    homepage = "https://ffmpeg.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      findus
    ];
  };
}
