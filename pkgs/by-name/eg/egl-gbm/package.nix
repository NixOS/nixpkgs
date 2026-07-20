{
  lib,
  stdenv,
  fetchFromGitHub,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  libGL,
  libgbm,
  libdrm,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "egl-gbm";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-gbm";
    tag = finalAttrs.version;
    hash = "sha256-OoHgvFbyd6JakSKyN7N97FMJHNYV1spj7zy3f1g/PN0=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libGL
    libgbm
    libdrm
    eglexternalplatform
  ];

  absolutizeEglExternalPlatformIcdJson = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "GBM EGL external platform library";
    homepage = "https://github.com/NVIDIA/egl-gbm/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ccicnce113424
    ];
  };
})
