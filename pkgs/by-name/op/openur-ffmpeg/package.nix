{
  ffmpeg-headless,
  fetchpatch2,
  lib,
}:

let
  version = "9.1.0.534";
  ffmpegVersion = "9.1";
in

(ffmpeg-headless.override {
  version = ffmpegVersion;
  hash = "sha256-XK9nk9wqoINbMqjTE6dWm4E5b3wmke4vsqeHshgu6UQ=";

  buildFfmpeg = false;
  buildFfplay = false;
  buildAvdevice = false;
  buildAvfilter = false;
  buildPostproc = false;
  buildSwresample = false;
  buildSwscale = false;

  withAlsa = false;
  withAmf = false;
  withAom = false;
  withAss = false;
  withBluray = false;
  withBzlib = false;
  withCudaLLVM = false;
  withCurl = false;
  withCuvid = false;
  withDrm = false;
  withDvdnav = false;
  withDvdread = false;
  withGmp = false;
  withHarfbuzz = false;
  withNetwork = false;
  withNvcodec = false;
  withFontconfig = false;
  withFreetype = false;
  withFribidi = false;
  withGnutls = false;
  withIconv = false;
  withLzma = false;
  withMp3lame = false;
  withOpenapv = false;
  withOpencl = false;
  withOpenjpeg = false;
  withOpenmpt = false;
  withOpus = false;
  withRist = false;
  withRubberband = false;
  withSoxr = false;
  withSpeex = false;
  withSrt = false;
  withSsh = false;
  withSvtav1 = false;
  withTheora = false;
  withV4l2 = false;
  withVaapi = false;
  withVidStab = false;
  withVorbis = false;
  withVpx = false;
  withVulkan = false;
  withWebp = false;
  withX264 = false;
  withX265 = false;
  withXml2 = false;
  withXvid = false;
  withZimg = false;
  withZlib = false;
  withZvbi = false;
}).overrideAttrs
  (old: {
    pname = "openur-ffmpeg";
    inherit version;
    __intentionallyOverridingVersion = true;

    patches = old.patches ++ [
      (fetchpatch2 {
        name = "v9.1_dts_es_audio.patch";
        url = "https://github.com/Openur/ffprobe-static-build/raw/refs/tags/v${version}/patches/v9.1_dts_es_audio.patch";
        hash = "sha256-w7aV2u9N44mKswzzP2bW8CtRa3F/iNMeeiYBM+Bq2XQ=";
      })
      (fetchpatch2 {
        name = "v9.1_x2645_codec_tag.patch";
        url = "https://github.com/Openur/ffprobe-static-build/raw/refs/tags/v${version}/patches/v9.1_x2645_codec_tag.patch";
        hash = "sha256-oNdmwD4y/vj/XyhZawkFYQcZebB31XKdA0V45mRADMk=";
      })
    ];

    configureFlags = old.configureFlags ++ [
      "--extra-version=Openur"

      # Disable unused functionalities
      "--disable-encoders"
      "--disable-muxers"
      "--disable-protocols"
      "--disable-bsfs"

      # FFMpeg options - enable what we need
      "--enable-protocol=file"
      "--disable-decoder=ahx"
      "--enable-bsf=av1_frame_split"
      "--enable-bsf=av1_frame_merge"
      "--enable-bsf=av1_metadata"
    ];

    doCheck = false;

    meta = {
      inherit (old.meta) license pkgConfigModules;
      mainProgram = "ffprobe";
      description = "${old.meta.description} (Openur fork)";
      homepage = "https://github.com/Openur/ffprobe-static-build";
      maintainers = with lib.maintainers; [ nyanloutre ];
    };
  })
