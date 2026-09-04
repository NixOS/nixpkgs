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
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-gbm";
    tag = finalAttrs.version;
    hash = "sha256-98NyUMpEN2uBSMnX2FTQvtn+RNpsVYOjgTagbcaPMME=";
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
