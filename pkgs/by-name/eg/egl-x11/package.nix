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
  libx11,
  libxcb,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "egl-x11";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-x11";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sl/qc39H29wXsb5UYKGK7IciwTlbRBqA9omL2sgXpx0=";
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
    libx11
    libxcb
    eglexternalplatform
  ];

  absolutizeEglExternalPlatformIcdJson = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "X11/XCB external platform library";
    homepage = "https://github.com/NVIDIA/egl-x11/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ccicnce113424
    ];
  };
})
