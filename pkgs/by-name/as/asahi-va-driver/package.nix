{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libva,
  libdrm,
  linuxHeaders,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "asahi-va-driver";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "asahi-va-driver";
    tag = finalAttrs.version;
    hash = "sha256-caIFHEBrgMhxLoXLJCn3JrZPcy3MAox5apXjvy3RxI8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libva
    libdrm
    linuxHeaders
  ];

  mesonFlags = [
    "-Ddriverdir=${placeholder "out"}/lib/dri"
  ];

  meta = {
    description = "VA-API (libva) backend driver for V4L2 stateless video decoders.";
    longDescription = ''
      A fork of the upstream https://xff.cz/git/libva-v4l2_request/. This version focuses on Apple Silicon.

      When support is available in the kernel and hardware, this allows hardware decoding of MPEG-2, H.264, HEVC, VP8, VP9 and AV1 through VA-API. AVD has support for all of these apart from VP8 and MPEG-2, though AV-1 is only supported on M3+.
    '';
    homepage = "https://github.com/AsahiLinux/asahi-va-driver";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      flokli
      sempiternal-aurora
    ];
    platforms = lib.platforms.linux;
  };
})
