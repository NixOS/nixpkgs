{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  autoAddDriverRunpath,
  libdrm,
  libGL,
  gst_all_1,
  nv-codec-headers-11,
  libva,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nvidia-vaapi-driver";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "elFarto";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KeOg9VvPTqIo0qB+dcU915yTztvFxo1jJcHHpsmMmfk=";
  };

  patches = [
    ./0001-hardcode-install_dir.patch
    (fetchpatch {
      # Quick fix for driver version 575 failures.
      url = "https://github.com/elFarto/nvidia-vaapi-driver/commit/0ef97c1849fac3e07cdf39ffe4cd9aa9f352896f.patch";
      hash = "sha256-Hyo5iO7/Ls5R1pRJo7FhKE3RPihc2xTh619HCFaODEg=";
      # Last part of the patch wasn't in the release, drop it.
      postFetch = ''
        head -n -10 "$out" > truncated.patch
        mv truncated.patch "$out"
      '';
    })
    (fetchpatch {
      # Fix 545.29 driver version check.
      url = "https://github.com/elFarto/nvidia-vaapi-driver/commit/14b519df56fe2655248c54d1553bced51ac154a9.patch";
      hash = "sha256-72mpEyhaSMXdrSkCicYh9ezR5pxGydXQV3nu4mCdvNo=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    autoAddDriverRunpath
  ];

  buildInputs = [
    libdrm
    libGL
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    nv-codec-headers-11
    libva
  ];

  meta = with lib; {
    homepage = "https://github.com/elFarto/nvidia-vaapi-driver";
    description = "VA-API implemention using NVIDIA's NVDEC";
    changelog = "https://github.com/elFarto/nvidia-vaapi-driver/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
})
