{
  ffmpeg-headless,
  fetchFromGitHub,
  fetchpatch2,
  lib,
}:

let
  version = "5.1.4";
in

(ffmpeg-headless.override {
  inherit version; # Important! This sets the ABI.

  # Fetch commit hash from this repository: https://github.com/Servarr/ffmpeg-build
  # Compare build logs to upstream logs here: https://dev.azure.com/Servarr/Servarr/_build?definitionId=15
  source = fetchFromGitHub {
    owner = "Servarr";
    repo = "FFmpeg";
    rev = "e9230b4c9027435dd402a68833f144643a3df43a";
    hash = "sha256-oMIblMOnnYpKvYeleCZpFZURGVc3fDAlYpOJu+u7HkU=";
  };

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
  withCuvid = false;
  withDrm = false;
  withNvcodec = false;
  withFontconfig = false;
  withFreetype = false;
  withFribidi = false;
  withGnutls = false;
  withIconv = false;
  withLzma = false;
  withMp3lame = false;
  withOpencl = false;
  withOpenjpeg = false;
  withOpenmpt = false;
  withOpus = false;
  withRist = false;
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
    pname = "servarr-ffmpeg";

    patches = old.patches ++ [
      (fetchpatch2 {
        name = "fix_build_failure_due_to_libjxl_version_to_new";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/75b1a555a70c178a9166629e43ec2f6250219eb2";
        hash = "sha256-+2kzfPJf5piim+DqEgDuVEEX5HLwRsxq0dWONJ4ACrU=";
      })
    ];

    configureFlags = old.configureFlags ++ [
      "--extra-version=Servarr"

      # https://github.com/Servarr/ffmpeg-build/blob/bc29af6f0bf84bf9253d4d462611b1dc31ee688e/common.sh#L15-L45

      # Disable unused functionnalities
      "--disable-encoders"
      "--disable-muxers"
      "--disable-protocols"
      "--disable-bsfs"

      # FFMpeg options - enable what we need
      "--enable-protocol=file"
      "--enable-bsf=av1_frame_split"
      "--enable-bsf=av1_frame_merge"
      "--enable-bsf=av1_metadata"
    ];

    doCheck = false;

    meta = {
      inherit (old.meta) license pkgConfigModules;
      mainProgram = "ffprobe";
      description = "${old.meta.description} (Servarr fork)";
      homepage = "https://github.com/Servarr/FFmpeg";
      maintainers = with lib.maintainers; [ nyanloutre ];
    };
  })
