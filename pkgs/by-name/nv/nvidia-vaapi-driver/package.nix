{
  lib,
  stdenv,
  fetchFromGitHub,
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
