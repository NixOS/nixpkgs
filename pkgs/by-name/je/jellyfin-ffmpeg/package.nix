{ ffmpeg
, fetchFromGitHub
, fetchpatch
, lib
}:

let
  version = "7.0.2-5";
in

(ffmpeg.override {
  inherit version; # Important! This sets the ABI.
  source = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    hash = "sha256-cqyXQNx65eLEumOoSCucNpAqShMhiPqzsKc/GjKKQOA=";
  };

  ffmpegVariant = "barebones";

  # https://github.com/NixOS/nixpkgs/pull/354936#issuecomment-2466628369
  # https://github.com/jellyfin/jellyfin-ffmpeg/blob/jellyfin/debian/rules
  # --enable-gmp # not supported by our ffmpeg drv
  withDoc = false;
  buildFfplay = false;
  withXcb = false;
  withSdl2 = false;
  withXlib = false;
  withGPL = true;
  withVersion3 = true;
  withShared = true;
  withGnutls = true;
  withChromaprint = true;
  withOpencl = true;
  withDrm = true;
  withXml2 = true;
  withAss = true;
  withFreetype = true;
  withFribidi = true;
  withFontconfig = true;
  withHarfbuzz = true;
  withBluray = true;
  withMp3lame = true;
  withOpus = true;
  withTheora = true;
  withVorbis = true;
  withOpenmpt = true;
  withDav1d = true;
  withSvtav1 = true;
  withWebp = true;
  withVpx = true;
  withX264 = true;
  withX265 = true;
  withZvbi = true;
  withZimg = true;
  withFdkAac = true;

  withShaderc = true;
  withPlacebo = true;
  withVulkan = true;
  withVaapi = true;
  withAmf = true;
  withVpl = true;
  withNvcodec = true;
  withCuda = true;
  withCudaLLVM = true;
  withCuvid = true;
  withNvdec = true;
  withNvenc = true;

  # Unlike upstream, these aren't enabled in the barebones variant by default
  # but we do need them to do anything useful.
  buildFfmpeg = true;
  # TODO are all of these actually required?
  buildAvcodec = true;
  buildAvdevice = true;
  buildAvfilter = true;
  buildAvformat = true;
  buildAvutil = true;
  buildPostproc = true;
  buildSwresample = true;
  buildSwscale = true;
}).overrideAttrs (old: {
  pname = "jellyfin-ffmpeg";

  configureFlags = old.configureFlags ++ [
    "--extra-version=Jellyfin"
    "--disable-ptx-compression" # https://github.com/jellyfin/jellyfin/issues/7944#issuecomment-1156880067
  ];

  postPatch = ''
    for file in $(cat debian/patches/series); do
      patch -p1 < debian/patches/$file
    done

    ${old.postPatch or ""}
  '';

  meta = {
    inherit (old.meta) license mainProgram;
    changelog = "https://github.com/jellyfin/jellyfin-ffmpeg/releases/tag/v${version}";
    description = "${old.meta.description} (Jellyfin fork)";
    homepage = "https://github.com/jellyfin/jellyfin-ffmpeg";
    maintainers = with lib.maintainers; [ justinas ];
    pkgConfigModules = [ "libavutil" ];
  };
})
