{
  lib,
  stdenv,
  fetchFromGitHub,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  libGL,
  libgbm,
  libdrm,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "egl-wayland2";
  version = "1.0.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-wayland2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Udr+tihx/Si2ynFyM1FW2CIUgTg9SQn7AgrOPpGTxpY=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libgbm
    libdrm
    wayland
    wayland-protocols
  ];

  propagatedBuildInputs = [
    eglexternalplatform
  ];

  postInstall = ''
    substituteInPlace $out/share/egl/egl_external_platform.d/09_nvidia_wayland2.json \
      --replace-fail "libnvidia-egl-wayland2.so.1" "$out/lib/libnvidia-egl-wayland2.so.1"
  '';

  meta = {
    description = "Dma-buf-based Wayland external platform library";
    homepage = "https://github.com/NVIDIA/egl-wayland2/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ vancluever ];
  };
})
