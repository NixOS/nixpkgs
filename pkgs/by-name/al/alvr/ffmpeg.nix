{
  lib,
  ffmpeg_6,
  alvr,
}:

(ffmpeg_6.override {
  version = "6.0";
  hash = "sha256-RVbgsafIbeUUNXmUbDQ03ZN42oaUo0njqROo7KOQgv0=";

  withHardcodedTables = false;

  withHtmlDoc = false;
  withManPages = false;
  withPodDoc = false;
  withTxtDoc = false;
  withDocumentation = false;
}).overrideAttrs
  (old: {
    # apply our own ffmpeg patches, but skip texinfo-7.1.patch as it does not apply to 6.0.
    # apply upstream patches for ALVR as well.
    patches =
      (lib.filter (p: !(lib.hasSuffix "texinfo-7.1.patch" (baseNameOf (toString p)))) old.patches)
      ++ [
        (alvr.src + "/alvr/xtask/patches/0001-Add-AV_VAAPI_DRIVER_QUIRK_HEVC_ENCODER_ALIGN_64_16-f.patch")
        (alvr.src + "/alvr/xtask/patches/0001-av1-encode-backport.patch")
        (alvr.src + "/alvr/xtask/patches/0001-clip-constants-used-with-shift-instr.patch")
        (alvr.src + "/alvr/xtask/patches/0001-guid-conftest.patch")
        (alvr.src + "/alvr/xtask/patches/0001-lavu-hwcontext_vulkan-Fix-importing-RGBx-frames-to-C.patch")
        (alvr.src + "/alvr/xtask/patches/0001-update-rc-modes.patch")
        (alvr.src + "/alvr/xtask/patches/0001-vaapi_encode-Add-filler_data-option.patch")
        (alvr.src + "/alvr/xtask/patches/0001-vaapi_encode-Allow-to-dynamically-change-bitrate-and.patch")
        (alvr.src + "/alvr/xtask/patches/0001-vaapi_encode-Enable-global-header.patch")
        (alvr.src + "/alvr/xtask/patches/0001-vaapi_encode_h265-Set-vui_parameters_present_flag.patch")
      ];

    doCheck = false;
  })
